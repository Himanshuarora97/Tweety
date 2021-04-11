//
//  AuthService.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Service responsible for handling  `Log In`, `Sign up` and `Log out`
class AuthService {
    
    static let shared = AuthService()
    
    public var uid: String? {
        get {
            Auth.auth().currentUser?.uid
        }
    }
    
    private var currentLoginUser: User? {
        didSet {
            currentLoginUser?.saveToPrefs(key: "user")
        }
    }
    
    /// Use this to for `log in` purpose
    public func signIn(with email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            self.handleResponse(result: result, error: error, completion: completion)
            
        }
        
    }
    
    
    private func handleResponse(result: AuthDataResult?, error: Error?,
                                completion: @escaping ((Error?) -> Void)) {
        if let error = error {
            completion(error)
            return
        }
        
        guard let uid = result?.user.uid else {
            return
        }
        
        // fetch the user and set to current login user
        UserService.shared.getUser(withId: uid) { (user, error) in
            if let user = user {
                self.currentLoginUser = user
                completion(nil)
            } else {
                completion(error!)
            }
        }
    }
    
    public func logOutUser() {
        do {
            currentLoginUser = nil
            User.removeFromPrefs(key: "user")
            try Auth.auth().signOut()
        } catch let error {
            print("Logout user error: ", error.localizedDescription)
        }
    }
    
    public func test() {
        guard let uid = uid else { return }
        // fetch the user and set to current login user
        UserService.shared.getUser(withId: uid) { (user, error) in
            if let user = user {
                self.currentLoginUser = user
            } else {
                print(error!)
            }
        }
    }
    
    public func isUserLoggedIn() -> Bool {
        return getLoginUser() != nil
    }
    
    public func getLoginUser() -> User? {
        if (currentLoginUser != nil) {
            return currentLoginUser
        }
        return User.getFromPrefs(key: "user")
    }
    
}


// MARK: SignUp
extension AuthService {
    
    /// Use this to for `sign up` purpose
    public func registerUser(withUser user: User, password: String, completion: @escaping ((Error?) -> Void)) {
        
        Auth.auth().createUser(withEmail: user.email, password: password) { (result, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            do {
                let _ = try FBCollection.USER_COLLECTION_REF.document(uid).setData(from: user) { (error) in
                    if error == nil { // if no error then store the current user as login user
                        self.currentLoginUser = user
                    }
                    completion(error)
                }
            } catch let error {
                completion(error)
            }
            
        }
        
    }
    
    
}
