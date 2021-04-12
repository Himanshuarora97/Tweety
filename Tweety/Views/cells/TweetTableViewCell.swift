//
//  TweetTableViewCell.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//

import UIKit
import SuperStackView
import SDWebImage


protocol TweetTableViewCellDelegate: class {
    func didTapOnOptions(_ cell: TweetTableViewCell, tweet: Tweet)
}

class TweetTableViewCell: UITableViewCell {
    
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
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .bold(size: 14)
        return label
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .regular(size: 12)
        return label
    }()
    
    private lazy var tweetTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.font = .regular(size: 12)
        return label
    }()
    
    private lazy var tweetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        
        label.font = .semibold(size: 18)
        return label
    }()
    
    private lazy var vStackView: SuperStackView = {
        let stackView = SuperStackView()
        stackView.stack.axis = .vertical
        stackView.hidesSeparatorsByDefault = true
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private lazy var hStackView: SuperStackView = {
        let stackView = SuperStackView()
        stackView.stack.axis = .horizontal
        stackView.hidesSeparatorsByDefault = true
        stackView.addRow(fullNameLabel)
        stackView.addRow(tweetTimeLabel, inset: UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6))
        stackView.addRow(chevronDownBtn)
        return stackView
    }()
    
    private lazy var chevronDownBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "chevron_down"), for: .normal)
        btn.setContentHuggingPriority(.required, for: .horizontal)
        btn.setContentCompressionResistancePriority(.required, for: .horizontal)
        btn.addTarget(self, action: #selector(didTapOnChevron), for: .touchUpInside)
        return btn
    }()
    
    weak var delegate: TweetTableViewCellDelegate?

    
    deinit {
        TimeHelper.shared.removeListener(self)
    }
    
    open var tweet: Tweet? {
        didSet {
            setTweet()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        vStackView.roundCorners(corners: [.topRight, .bottomLeft, .bottomRight], radius: 8)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        setUpViews()
        setUpTimeHelper()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.backgroundColor = .clear
        vStackView.addRow(hStackView, inset: UIEdgeInsets(top: 6, left: 12, bottom: 2, right: 12))
        vStackView.addRow(userNameLabel, inset: UIEdgeInsets(top: 2, left: 12, bottom: 2, right: 12))
        vStackView.addRow(tweetLabel, inset: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        self.addSubview(vStackView)
        self.addSubview(avatarImage)
    }
    
    private func setUpTimeHelper() {
        TimeHelper.shared.addListener(self)
    }
    
    private func setUpConstraints() {
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        avatarImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        
        vStackView.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 12).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        vStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        
        self.bottomAnchor.constraint(equalTo: vStackView.bottomAnchor, constant: 12).isActive = true
    }
    
    
}

extension TweetTableViewCell {
    
    private func setTweet() {
        guard let tweet = tweet else { return }
        
        userNameLabel.text = "@\(tweet.user.username)"
        fullNameLabel.text = tweet.user.fullName
        tweetLabel.text = tweet.tweetText
        let isCurrentUser = tweet.isCurrentUserTweet
        hStackView.setRowHidden(chevronDownBtn, isHidden: !isCurrentUser)
        if let profileUrl = tweet.user.profileUrl, !profileUrl.isEmpty,
           let url = URL(string: profileUrl) {
            avatarImage.sd_setImage(with: url, placeholderImage: UIImage(named: "default_avatar"), options: [], completed: nil)
        } else {
            avatarImage.image = UIImage.init(named: "default_avatar")
        }
        timerUpdated()
    }
    
}

extension TweetTableViewCell {
    
    @objc func didTapOnChevron() {
        guard let tweet = tweet else { return }
        delegate?.didTapOnOptions(self, tweet: tweet)
    }
    
}

extension TweetTableViewCell: TimeHelperDelegate {
    
    func timerUpdated() {
        guard let tweet = tweet else { return }
        let currenText = tweetTimeLabel.text
        let elapsedTimeStr = tweetElapsedTime(tweetTimeStamp: tweet.timestamp)
        if (currenText != elapsedTimeStr) {
            tweetTimeLabel.text = elapsedTimeStr
        }
    }
    
}

extension TweetTableViewCell {
    
    private func tweetElapsedTime(tweetTimeStamp: Double) -> String {
        let diff = Int(Date().timeIntervalSince1970) - Int(tweetTimeStamp)
        if (diff < 60) {
            return "Just Now"
        } else if (diff < 3600) {
            let min = diff / 60
            return "\(min)m ago"
        } else if (diff / 3600 < 24) {
            let hour = diff / 3600
            return "\(hour)h ago"
        }
        return "\(diff / 86400)d ago"
    }
    
}
