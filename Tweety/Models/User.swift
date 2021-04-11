//
//  User.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import Foundation

struct User: Codable, TweetyCodable {
    
    let username: String
    let email: String
    let fullName: String
    let profileUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
        case fullName = "fullname"
        case profileUrl = "profile_url"
    }
    
}
