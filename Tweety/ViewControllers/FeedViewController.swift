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
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        setUpConstraints()
    }
    
    private func setUpViews() {
        self.view.backgroundColor = .bgColor
        FeedService.shared.addListener(self)
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
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
        cell.selectionStyle = .none
        return cell
    }
    
}


// MARK: Selectors
extension FeedViewController {
    
    @objc func didTapOnAddTweetBtn() {
    }
    
    @objc func didTapOnLogoutBtn() {
        showLogoutAlert()
    }
    
}

// MARK: Delegates
extension FeedViewController: FeedServiceDelegate {
    
    func addTweet(_ tweet: Tweet) {
        let isEmpty = tweets.isEmpty
        tweets.append(tweet)
        if (isEmpty) {
            tableView.reloadData()
        } else {
            print("DEBUG://", tweet.id!, tweets)
            tableView.insertRows(at: [IndexPath(row: tweets.endIndex - 1, section: 0)], with: .right)
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
        tableView.reloadRows(at: changeIndex, with: .fade)
    }
    
    func deleteAvailable(_ tweet: Tweet) {
        if let index = tweets.firstIndex(where: { $0.id! == tweet.id }) {
            tweets.remove(at: index)
        }
        let isEmpty = tweets.isEmpty
        if (isEmpty) {
            tableView.reloadData()
        } else {
            tableView.deleteRows(at: [IndexPath(row: tweets.endIndex, section: 0)], with: .left)
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
        AuthService.shared.logOutUser()
        tableView.reloadData()
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
