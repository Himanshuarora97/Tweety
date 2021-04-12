//
//  Tweet.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Tweet: Identifiable, Codable {
    
    @DocumentID var id: String? = UUID().uuidString
    let tweetText: String
    let timestamp: Double
    let user: User
    var isCurrentUserTweet: Bool {
        get {
            if let email = AuthService.shared.getLoginUser()?.email {
                let tweetEmail = user.email
                return email == tweetEmail
            }
            return false
        }
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case timestamp
        case tweetText = "tweet"
        case user
    }
    
    func getUpdatedTweet(text: String) -> Tweet {
        let newTweet = Tweet(id: id, tweetText: text, timestamp: timestamp, user: user)
        return newTweet
    }
    
    
}
