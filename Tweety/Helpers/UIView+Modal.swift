//
//  UIView+Modal.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import UIKit

protocol Modal {
    func show(animated:Bool, showOnKeyboard: Bool)
    func dismiss(animated:Bool, type: ModelAnimType)
    var backgroundView:UIView {get}
    var dialogView:UIView {get set}
}

enum ModelAnimType: Int {
    case translation = 0, fade = 1
}

extension Modal where Self:UIView{
    
    func show(animated:Bool = true, showOnKeyboard: Bool = true){
        // dismiss on click outside (enable or disable the user interaction)
        self.backgroundView.isUserInteractionEnabled = false
        self.backgroundView.alpha = 0
        

        let windows = UIApplication.shared.windows
        if (windows.isEmpty == false && !windows[windows.count - 1].isHidden && showOnKeyboard) {
            windows[windows.count - 1].addSubview(self)
        } else {
            UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)
        }
        
        
        if animated {
            showAnimation()
        } else{
            self.backgroundView.alpha = 0.66
            self.dialogView.center  = self.center
        }
    }
    
    func dismiss(animated:Bool, type: ModelAnimType = .translation){
        if animated {
            hideAnimation()
        }else{
            self.removeFromSuperview()
        }
    }
    
    private func showAnimation() {
        self.dialogView.center = self.center
        self.dialogView.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0.66
            self.dialogView.alpha = 1
        })
    }
    
    private func hideAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0
            self.dialogView.alpha = 0
        }, completion: { (completed) in
            self.removeFromSuperview()
        })
    }
}
