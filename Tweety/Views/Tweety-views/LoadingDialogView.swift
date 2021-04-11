//
//  LoadingDialogView.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import UIKit

class LoadingDialogView: UIView, Modal {
    
    var backgroundView = UIView()
    
    var dialogView = UIView()

    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .bold(size: 20)
        label.textColor = .white
        return label
    }()
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(title: String) {
        // for full width and height
        self.init(frame: UIScreen.main.bounds)
        titleLabel.text = title
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUpViews() {
        setUpBackgroundView()
        setUpDialogView()
        setUpUIActivityIndicator()
        setUpLabels()
    }
    
    private func setUpBackgroundView() {
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        addSubview(backgroundView)
    }
    
    private func setUpDialogView() {
        dialogView.layer.cornerRadius = 8
        dialogView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addSubview(dialogView)
    }
    
    private func setUpUIActivityIndicator() {
        activityIndicator.color = .white
        dialogView.addSubview(activityIndicator)
    }
    
    private func setUpLabels() {
        dialogView.addSubview(titleLabel)
    }
    
    private func setUpConstraints() {
        setUpContainerConstraints()
    }
    
    private func setUpContainerConstraints() {
        let subviews = [titleLabel, dialogView, activityIndicator]
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        activityIndicator.startAnimating()
        activityIndicator.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 20).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor).isActive = true
        
        
        titleLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -12).isActive = true

        
        dialogView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        dialogView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 64).isActive = true
        dialogView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -64).isActive = true
        dialogView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
