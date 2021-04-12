//
//  FeedService.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FeedServiceDelegate: class {
    func addTweet(_ tweet: Tweet)
    func deleteAvailable(_ tweet: Tweet)
    func updateTweetAvailable(_ tweet: Tweet)
}

class FeedService {
    
    private var listeners = WeakArray<AnyObject>()
    
    
    static let shared = FeedService()
    
    private var snapshotListener: ListenerRegistration?
    
    
    init() {
        attachListener()
    }
    
    public func postTweet(tweet: String, completion: @escaping ((Error?) -> Void)) {
        guard let currentUser = AuthService.shared.getLoginUser() else { return }
        let timestamp = Date().timeIntervalSince1970
        let tweet = Tweet(id: nil, tweetText: tweet, timestamp: timestamp, user: currentUser)
        do {
            let _ = try FBCollection.TWEETS_COLLECTION_REF.addDocument(from: tweet, completion: completion)
        } catch let error {
            completion(error)
            print("ERROR:// ", error.localizedDescription)
        }
    }
    
    
    private func attachListener() {
        if (snapshotListener != nil) {
            return
        }
        let query = FBCollection.TWEETS_COLLECTION_REF.whereField("timestamp", isNotEqualTo: false).order(by: "timestamp")
        snapshotListener = query.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                
                guard let tweet = try? diff.document.data(as: Tweet.self) else { return }
                print("DEBUG://", diff.document.data())
                self.broadcastTweet(diffType: diff.type, tweet: tweet)
            }
        }
    }
    
}

// MARK: Update
extension FeedService {
    
    public func updateTweet(tweet: Tweet, completion: @escaping ((Error?) -> Void)) {
        guard let id = tweet.id else { return }
        try? FBCollection.TWEETS_COLLECTION_REF.document(id).setData(from: tweet, completion: completion)
    }
    
}

// MARK: Delete
extension FeedService {
    
    public func deleteTweet(tweet: Tweet, completion: @escaping ((Error?) -> Void)) {
        guard let id = tweet.id else { return }
        FBCollection.TWEETS_COLLECTION_REF.document(id).delete(completion: completion)
    }
    
}

extension FeedService {
    
    private func broadcastTweet(diffType: DocumentChangeType, tweet: Tweet) {
        for listener in (listeners.filter { $0 != nil }){
            guard let currentClass = listener as? FeedServiceDelegate else {
                continue
            }
            if (diffType == .added) {
                currentClass.addTweet(tweet)
            }
            if (diffType == .modified) {
                currentClass.updateTweetAvailable(tweet)
                
            }
            if (diffType == .removed) {
                currentClass.deleteAvailable(tweet)
            }
            
        }
    }
    
}


extension FeedService {
    
    
    func addListener(_ object: AnyObject) {
        listeners.insert(element: object)
    }
    
    func removeListener(_ object: AnyObject) {
        listeners.remove(element: object)
    }
    
    func removeSnapshotListener() {
        snapshotListener?.remove()
    }
    
    func startSnapshotListener() {
        attachListener()
    }
    
}

