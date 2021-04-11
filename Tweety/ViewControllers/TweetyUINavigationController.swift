//
//  TweetyUINavigationController.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//

import UIKit

class TweetyUINavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}
