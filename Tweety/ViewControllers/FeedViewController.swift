//
//  FeedViewController.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//

import Foundation
import UIKit

class FeedViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 44
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.reuseIdentifier)
        return table
    }()
    
    private lazy var addTweetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .brandBlueColor
        button.setImage(UIImage(named: "ic_add_tweet"), for: .normal)
        button.addTarget(self, action: #selector(didTapOnAddTweetBtn), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .semibold(size: 14)
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(didTapOnLogoutBtn), for: .touchUpInside)
        return button
    }()
    
    private var tweets = [Tweet]()
    private var isViewAlreadyLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if (!AuthService.shared.isUserLoggedIn()) {
            showLoginViewController()
        } else {
            configureUI()
        }
    }
    
    private func showLoginViewController() {
        DispatchQueue.main.async {
            let vc = TweetyUINavigationController(rootViewController: LoginViewController())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        if (!isViewAlreadyLoaded) {
            isViewAlreadyLoaded = true
            setUpViews()
            setUpConstraints()
        }
        FeedService.shared.addListener(self)
        FeedService.shared.startSnapshotListener()
    }
    
    private func setUpViews() {
        self.view.backgroundColor = .bgColor
        setUpNavigation()
        setUpTableView()
        setUpAddTweetButton()
    }
    
    private func setUpNavigation() {
        let image = UIImage(named: "ic_twitter_logo")
        let imageView = UIImageView(image: image)
        navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    
    private func setUpAddTweetButton() {
        view.addSubview(addTweetButton)
    }
    
    
}


// MARK: Constraints
extension FeedViewController {
    
    private func setUpConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addTweetButton.translatesAutoresizingMaskIntoConstraints = false
        
        setUpTableViewConstraints()
        setUpAddTweetButtonConstraints()
    }
    
    private func setUpTableViewConstraints() {
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setUpAddTweetButtonConstraints() {
        let buttonSize: CGFloat = 56
        addTweetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -12).isActive = true
        addTweetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -12).isActive = true
        addTweetButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        addTweetButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        addTweetButton.layer.cornerRadius = buttonSize/2
    }
    
}

// MARK: UITableviewDelegate, UITableViewDatasource
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tweets.isEmpty) {
            setEmptyView()
            return 0
        }
        if (tableView.backgroundView != nil) {
            restore()
        }
        return tweets.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.reuseIdentifier, for: indexPath) as! TweetTableViewCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
}

extension FeedViewController: TweetTableViewCellDelegate {
    
    func didTapOnOptions(_ cell: TweetTableViewCell, tweet: Tweet) {
        openActionSheet(tweet: tweet)
    }
    
    private func openActionSheet(tweet: Tweet) {
        let optionMenu = UIAlertController(title: nil, message: "Choose option", preferredStyle: .actionSheet)

        let editTweetAction = UIAlertAction(title: "Edit Tweet", style: .default, handler:{ (UIAlertAction) in
            self.editTweet(tweet: tweet)
        })
        
        let deleteTweetAction = UIAlertAction(title: "Delete Tweet", style: .destructive, handler:{ (UIAlertAction) in
            self.deleteTweet(tweet: tweet)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        optionMenu.addAction(editTweetAction)
        optionMenu.addAction(deleteTweetAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func editTweet(tweet: Tweet) {
        let vc = TweetViewController(tweet: tweet)
        self.present(vc, animated: true, completion: nil)
    }
    
    private func deleteTweet(tweet: Tweet) {
        FeedService.shared.deleteTweet(tweet: tweet) { (error) in
            if let error = error {
                print("DEBUG:// ", "ERROR WHILE DELETE", error.localizedDescription)
                return
            }
            print("DEBUG:// ", "DELETE SUCCESS")
        }
    }
    
}


// MARK: Selectors
extension FeedViewController {
    
    @objc func didTapOnAddTweetBtn() {
        let vc = TweetyUINavigationController(rootViewController: TweetViewController())
        present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapOnLogoutBtn() {
        showLogoutAlert()
    }
    
}

// MARK: Delegates
extension FeedViewController: FeedServiceDelegate {
    
    func addTweet(_ tweet: Tweet) {
        let isEmpty = tweets.isEmpty
        if (isEmpty) {
            tweets.append(tweet)
            tableView.reloadData()
        } else {
            tweets.insert(tweet, at: 0)
            print("DEBUG://", tweet.id!, tweets)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        }
    }
    
    func updateTweetAvailable(_ tweet: Tweet) {
        var changeIndex = [IndexPath]()
        for (index, oldTweet) in tweets.enumerated() {
            let oldId = oldTweet.id!
            let newTweetId = tweet.id!
            if (oldId == newTweetId) {
                tweets[index] = tweet
                changeIndex.append(IndexPath(row: index, section: 0))
            }
        }
        tweets = tweets.sorted(by: { (tweet1, tweet2) -> Bool in
            return tweet1.timestamp > tweet2.timestamp
        })
        tableView.reloadData()
    }
    
    func deleteAvailable(_ tweet: Tweet) {
        guard let index = tweets.firstIndex(where: { $0.id! == tweet.id }) else {
            return
        }
        tweets.remove(at: index)
        let isEmpty = tweets.isEmpty
        if (isEmpty) {
            tableView.reloadData()
        } else {
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        }
    }

    
}


// MARK: Helpers
extension FeedViewController {
    
    private func showLogoutAlert(){
        let alert = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "No", style: .default, handler: {(alert: UIAlertAction!) -> Void in
        })
        let logout = UIAlertAction(title: "Yes", style: .destructive, handler: {(alert: UIAlertAction!) -> Void in
            self.logoutFromApp()
        })
        alert.addAction(cancel)
        alert.addAction(logout)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func logoutFromApp() {
        showLoginViewController()
        
        AuthService.shared.logOutUser()
        tweets = [Tweet]()
        tableView.reloadData()
        FeedService.shared.removeListener(self)
        FeedService.shared.removeSnapshotListener()
    }
    
    func setEmptyView() {
        let emptyView = FeedEmptyView(frame: CGRect(x: tableView.center.x, y: tableView.center.y, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        tableView.backgroundView = emptyView
        tableView.separatorStyle = .none
    }
    
    func restore() {
        tableView.backgroundView = nil
    }
    
}
