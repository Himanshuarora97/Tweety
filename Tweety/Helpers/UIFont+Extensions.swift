//
//  UIFont+Extensions.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import UIKit

extension UIFont {
    
    class func regular(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    class func semibold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    }
  
    class func bold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    
    class func heavy(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
    }
    
    
}
