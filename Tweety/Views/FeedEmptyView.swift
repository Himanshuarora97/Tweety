//
//  FeedEmptyView.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//

import UIKit
import SuperStackView

class FeedEmptyView: UIView {
    
    private lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Welcome to Tweety"
        label.font = .bold(size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "It's empty now, start your tweety journey"
        label.font = .regular(size: 16)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var vStackView: SuperStackView = {
        let stackView = SuperStackView()
        stackView.stack.axis = .vertical
        stackView.hidesSeparatorsByDefault = true
        stackView.addRow(headingLabel)
        stackView.addRow(descLabel, inset: UIEdgeInsets(top: 6, left: 12, bottom: 0, right: 12))
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.backgroundColor = .bgColor
        self.addSubview(vStackView)
    }
    
    private func setUpConstraints() {
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        vStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        vStackView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    
}

