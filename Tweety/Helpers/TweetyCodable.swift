//
//  TweetyCodable.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import Foundation

protocol TweetyCodable {
    
}

extension TweetyCodable where Self: Codable {
    
    func saveToPrefs(key: String){
        if let encodedData = try? JSONEncoder().encode(self){
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
    
    static func getFromPrefs<T>(key: String) -> T?{
        if let jsonData = UserDefaults.standard.data(forKey: key), let object = try? JSONDecoder().decode(Self.self, from: jsonData) {
            return object as? T
        } else {
            return nil
        }
    }
    
    static func removeFromPrefs(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}
