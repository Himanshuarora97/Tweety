//
//  UITableView+Extensions.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//

import UIKit

protocol ReuseIdentifier where Self : UITableViewCell {
    static var reuseIdentifier : String { get }
}

extension UITableViewCell : ReuseIdentifier {
    static var reuseIdentifier : String {
        return String(describing: self)
    }
}
