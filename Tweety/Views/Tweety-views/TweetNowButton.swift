//
//  TweetNowButton.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//


import UIKit
import AVKit

protocol TweetNowButtonDelegate: class {
    func didTapOnTweetNowButton()
}

class TweetNowButton: UIView {
    
    
    public lazy var containerView: UIView  = {
        let view = UIView()
        let buttonHeight: CGFloat = 50
        view.backgroundColor = .brandBlueColor
        view.layer.cornerRadius = buttonHeight/2
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        return view
    }()
    
     public lazy var tweetNowLabel: UILabel = {
        let label = UILabel()
        label.font = .semibold(size: 16)
        label.textColor = .white
        label.text = "Tweet now"
        return label
    }()
    
    private lazy var progressView = CircularProgressView()
    
    open var numberOfChars: Int = 0 {
        didSet {
            setViewForChars(oldValue: oldValue)
        }
    }
    
    open var isEnabled: Bool = true {
        didSet {
            if (isEnabled != oldValue) {
                handleEnableButton()
            }
        }
    }
    
    weak var delegate: TweetNowButtonDelegate?
    
    private let PROGRESS_BAR_HEIGHT:CGFloat = 20
    private let PROGRESS_BAR_ZOOM_HEIGHT:CGFloat = 24
    private var progressViewHeightConstraint = NSLayoutConstraint()
    
    init() {
        super.init(frame: .zero)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        setUpContainerView()
        setUpTweetNowLabel()
        setUpCircularProgressView()
    }
    
    private func setUpContainerView() {
        containerView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnContainerView))
        containerView.addGestureRecognizer(tap)
        addSubview(containerView)
    }
    
    private func setUpTweetNowLabel() {
        containerView.addSubview(tweetNowLabel)
    }
    
    private func setUpCircularProgressView() {
        containerView.addSubview(progressView)
    }
    
    private func setUpConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        tweetNowLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpProgressViewConstriants()
        setUpTweetNowLabelConstraints()
        setUpContainerViewConstraints()
        setUpSelfConstraints()
        
    }
    
    private func setUpProgressViewConstriants() {
        progressViewHeightConstraint = progressView.heightAnchor.constraint(equalToConstant: 20)
        progressViewHeightConstraint.isActive = true
        progressView.widthAnchor.constraint(equalTo: progressView.heightAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12).isActive = true
    }
    
    private func setUpTweetNowLabelConstraints() {
        tweetNowLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        tweetNowLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    private func setUpContainerViewConstraints() {
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setUpSelfConstraints() {
        self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
}

// MARK: Button handling, Helpers
extension TweetNowButton {
    
    private func setViewForChars(oldValue: Int) {
        handlingProgressView(oldValue: oldValue)
        progressView.progress = min(1, CGFloat(numberOfChars) / CGFloat(Constants.TWEET_LIMIT))
    }
    
    private func handlingProgressView(oldValue: Int) {
        let vibrateLimit = Int(CGFloat(Constants.TWEET_LIMIT) * 0.9)
        // if number of character greater than vibrate limit
        if (numberOfChars > vibrateLimit) {
            
            // if old value is lower than vibrate limit
            // this happened only when moving from low chars to high chars
            if (oldValue <= vibrateLimit) {
                AudioServicesPlaySystemSound(SystemSoundID(1003))
            }
            
            handleAppearanceInVibrateMode()
        } else if (progressViewHeightConstraint.constant == PROGRESS_BAR_ZOOM_HEIGHT &&
                    progressViewHeightConstraint.constant != PROGRESS_BAR_HEIGHT) {
            bringProgressBartoOriginalPos()
        }
    }
    
    private func handleAppearanceInVibrateMode() {
        // if button not in zoom position
        if (progressViewHeightConstraint.constant != PROGRESS_BAR_ZOOM_HEIGHT) {
            
            progressViewHeightConstraint.constant = PROGRESS_BAR_ZOOM_HEIGHT
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
            
        }
        // if number of character larger then tweet limit, mark it as red
        if (numberOfChars > Constants.TWEET_LIMIT) {
            isEnabled = false
            progressView.progressStrokeColor = .red
        } else {
            isEnabled = true
            progressView.progressStrokeColor = .yellow
        }
    }
    
    private func bringProgressBartoOriginalPos() {
        progressView.progressStrokeColor = .white
        progressViewHeightConstraint.constant = PROGRESS_BAR_HEIGHT
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        isEnabled = true
    }
    
    private func handleEnableButton() {
        containerView.isUserInteractionEnabled = isEnabled
        if (isEnabled) {
            containerView.backgroundColor = .brandBlueColor
        } else {
            containerView.backgroundColor = .brandBlueDisableColor
        }
    }

    
}

// MARK: Selector
extension TweetNowButton {
    
    @objc func didTapOnContainerView() {
        delegate?.didTapOnTweetNowButton()
    }
    
}
