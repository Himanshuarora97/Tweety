//
//  KeyboardListener.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import UIKit

protocol KeyboardListener {
    func registerKeyboardNotifications()
    func deregisterKeyboardNotifications()
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
}

extension KeyboardListener where Self: UIViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey
                ]as? CGRect
            guard let height = keyboardSize?.height else {
                return
            }
            self?.keyboardWillShow(height: height)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillHide()
        }
    }
    
    func deregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
