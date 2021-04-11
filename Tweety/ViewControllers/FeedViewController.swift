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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        setUpConstraints()
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


// MARK: Selectors
extension FeedViewController {
    
    @objc func didTapOnAddTweetBtn() {
    }
    
    @objc func didTapOnLogoutBtn() {
        showLogoutAlert()
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
    
}
