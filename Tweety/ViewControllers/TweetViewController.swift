//
//  TweetViewController.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//


import Foundation
import UIKit

class TweetViewController: UIViewController {
    
    private lazy var tweetInputView: TweetyInputView = {
        let view = TweetyInputView()
        view.placeholder = "Enter the awesome tweet"
        view.isScrollEnabled = false
        view.isUserInteractionEnabled = true
        view.delegate = self
        view.backgroundColor = .white
        view.textColor = .black
        view.font = .semibold(size: 16)
        view.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        view.layer.borderColor = UIColor.greyColor.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        let imageSize: CGFloat = 50
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageSize/2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "New Tweet"
        label.font = .bold(size: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.init(named: "close_button"), for: .normal)
        button.addTarget(self, action: #selector(didTapOnCloseButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tweetNowButton = TweetNowButton()

    private let INPUT_VIEW_MIN_HEIGHT:CGFloat = 100
    private let INPUT_VIEW_MAX_HEIGHT:CGFloat = 200
    private var buttonBottomConstraint = NSLayoutConstraint()
    private var inputViewHeightConstraint = NSLayoutConstraint()
    private var inputViewGreaterThanHeightConstraint = NSLayoutConstraint()
    
    private var tweet: Tweet?
    
    
    deinit {
        deregisterKeyboardNotifications()
    }
    
    init(tweet: Tweet? = nil) {
        self.tweet = tweet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        setUpConstraints()
        registerKeyboardNotifications()
        tweetInputView.becomeFirstResponder()
        
        setDataInView()
        setAvatarImageURL()
    }
    
    private func setUpViews() {
        self.view.backgroundColor = .white
        setUpAvatarImageView()
        setUpTweetInputView()
        setUpNavigation()
        setUpAddTweetButton()
    }
    
    private func setUpAvatarImageView() {
        view.addSubview(avatarImage)
    }
    
    private func setUpTweetInputView() {
        view.addSubview(tweetInputView)
    }
    
    private func setUpNavigation() {
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationController?.navigationBar.barTintColor = .white
    }
    
    private func setUpAddTweetButton() {
        tweetNowButton.delegate = self
        view.addSubview(tweetNowButton)
    }
    
    private func setUpConstraints() {
        tweetNowButton.translatesAutoresizingMaskIntoConstraints = false
        
        setUpAvatarImageConstraints()
        setUpTweetInputViewConstraints()
        setUpAddTweetButtonConstraints()
    }
    
    private func setUpAvatarImageConstraints() {
        avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        avatarImage.topAnchor.constraint(equalTo: tweetInputView.topAnchor).isActive = true
    }
    
    private func setUpTweetInputViewConstraints() {
        tweetInputView.translatesAutoresizingMaskIntoConstraints = false
        tweetInputView.bottomAnchor.constraint(equalTo: tweetNowButton.topAnchor, constant: -32).isActive = true
        tweetInputView.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 12).isActive = true
        tweetInputView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        inputViewHeightConstraint = tweetInputView.heightAnchor.constraint(equalToConstant: INPUT_VIEW_MIN_HEIGHT)
        inputViewHeightConstraint.isActive = false
        inputViewGreaterThanHeightConstraint = tweetInputView.heightAnchor.constraint(greaterThanOrEqualToConstant: INPUT_VIEW_MIN_HEIGHT)
        inputViewGreaterThanHeightConstraint.isActive = true
    }
    
    private func setUpAddTweetButtonConstraints() {
        tweetNowButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                 constant: 12).isActive = true
        tweetNowButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -12).isActive = true
        buttonBottomConstraint = tweetNowButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -12)
        buttonBottomConstraint.isActive = true
        
    }

}

extension TweetViewController {
    
    @objc func didTapOnCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension TweetViewController {
    
    private func setDataInView() {
        guard let tweet = tweet else { return }
        tweetInputView.text = tweet.tweetText
        tweetNowButton.tweetNowLabel.text = "Update Tweet"
        textViewDidChange(tweetInputView)
    }
    
    private func setAvatarImageURL() {
        let userProfileURL = AuthService.shared.getLoginUser()?.profileUrl
        let url = tweet?.user.profileUrl ?? userProfileURL
        if let profileUrl = url, !profileUrl.isEmpty,
           let url = URL(string: profileUrl) {
            avatarImage.sd_setImage(with: url, placeholderImage: UIImage(named: "default_avatar"), options: [], completed: nil)
        } else {
            avatarImage.image = UIImage.init(named: "default_avatar")
        }
    }
    
}

extension TweetViewController: TweetNowButtonDelegate {
    
    func didTapOnTweetNowButton() {
        guard let text = tweetInputView.text else { return }
        if let tweet = tweet {
            updateTweet(tweet: tweet, text: text)
        } else {
            postTweet(text: text)
        }
    }
    
    private func postTweet(text: String) {
        FeedService.shared.postTweet(tweet: text) { (error) in
            if let error = error {
                print("DEBUG:// ", error.localizedDescription)
                return
            }
            print("DEBUG:// ", "Success")
            SoundHelper.sharedInstance.playTweetSound()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func updateTweet(tweet: Tweet, text: String) {
        let newTweet = tweet.getUpdatedTweet(text: text)
        FeedService.shared.updateTweet(tweet: newTweet) { (error) in
            if let error = error {
                print("DEBUG:// ", error.localizedDescription)
                return
            }
            print("DEBUG:// ", "Success")
            SoundHelper.sharedInstance.playTweetSound()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension TweetViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let chars = textView.text?.count ?? 0
        tweetNowButton.numberOfChars = chars
        handlingTextViewHeight(textView: textView)
    }
    
    private func handlingTextViewHeight(textView: UITextView) {
        if (textView.contentSize.height > INPUT_VIEW_MAX_HEIGHT) {
            textView.isScrollEnabled = true
            inputViewHeightConstraint.constant = INPUT_VIEW_MAX_HEIGHT
            inputViewHeightConstraint.isActive = true
        } else {
            textView.isScrollEnabled = false
            inputViewHeightConstraint.isActive = false
            if (textView.contentSize.height > INPUT_VIEW_MIN_HEIGHT) {
                inputViewGreaterThanHeightConstraint.isActive = false
            } else {
                inputViewGreaterThanHeightConstraint.isActive = true
            }
        }
    }
    
    
    
}


extension TweetViewController: KeyboardListener {
    
    func keyboardWillShow(height: CGFloat) {
        buttonBottomConstraint.constant = -height
    }
    
    func keyboardWillHide() {
        buttonBottomConstraint.constant = -12
    }
    
    
}
