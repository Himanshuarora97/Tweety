//
//  FBCollection.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import FirebaseFirestore

class FBCollection {
    
    static let COLLECTION_REF = Firestore.firestore()
    
    static let USER_COLLECTION_REF = COLLECTION_REF.collection("users")
    
}
