//
//  TwittyUIButton.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//

import UIKit

class TweetyUIButton: UIButton {

    private var margin:CGFloat = 20.0
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        //increase touch area for control in all directions by 20
        
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }

}
