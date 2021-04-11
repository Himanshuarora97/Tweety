//
//  UserService.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import Foundation

class UserService {
    
    static let shared = UserService()
    
    public func getUser(withId id: String, completion: @escaping ((User?, Error?) -> Void)) {
        FBCollection.USER_COLLECTION_REF.document(id).getDocument { (documentSnapshot, error) in
            
            if let error = error {
                completion(nil, error)
            } else if let documentSnapshot = documentSnapshot {
                if let user = try? documentSnapshot.data(as: User.self) {
                    completion(user, nil)
                }
            }
        }
    }
    
}
