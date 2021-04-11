//
//  UIColor+Colors.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import UIKit

extension UIColor {
    
    static let brandBlueColor = UIColor(rgb: 0x4C9EEB)
    static let brandBlueDisableColor = UIColor(rgb: 0x87bced)
    
    static let bgColor = UIColor(rgb: 0xE7ECF0)
    
    static let greyColor = UIColor(rgb: 0xF2F2F2)
    
}

extension UIColor {
    
    convenience init(rgb: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
}

