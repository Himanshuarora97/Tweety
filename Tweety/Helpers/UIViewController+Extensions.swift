//
//  UIViewController+Extensions.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import Foundation
import Toast_Swift

extension UIViewController {
    
    func showToast(message: String) {
        let windows = UIApplication.shared.windows
        windows.last?.makeToast(message)
    }
    
}
