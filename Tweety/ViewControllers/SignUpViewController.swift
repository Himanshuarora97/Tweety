//
//  SignUpViewController.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import UIKit
import SuperStackView

class SignUpViewController: UIViewController {
    
    private lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.font = .heavy(size: 48)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emailTextField: TweetyInputField = {
        let field = TweetyInputField()
        field.inputField.keyboardType = .emailAddress
        field.inputField.returnKeyType = .next
        field.setPlaceholder(text: "Email")
        return field
    }()
    
    private lazy var passwordInputField: TweetyInputField = {
        let field = TweetyInputField()
        field.inputField.isSecureTextEntry = true
        field.inputField.returnKeyType = .next
        field.setPlaceholder(text: "Password")
        return field
    }()
    
    private lazy var userNameField: TweetyInputField = {
        let field = TweetyInputField()
        field.inputField.returnKeyType = .next
        field.setPlaceholder(text: "Username")
        return field
    }()
    
    private lazy var fullNameField: TweetyInputField = {
        let field = TweetyInputField()
        field.setPlaceholder(text: "Fullname")
        return field
    }()
    
    private lazy var vStackView: SuperStackView = {
        let view = SuperStackView()
        view.stack.axis = .vertical
        view.hidesSeparatorsByDefault = true
        view.rowInset = UIEdgeInsets(top: 24, left: 0, bottom: 12, right: 0)
        view.addRow(emailTextField)
        view.addRow(passwordInputField)
        view.addRow(userNameField)
        view.addRow(fullNameField)
        view.addRow(signUpButton, inset: UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0))
        return view
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .brandBlueColor
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapOnSignUp), for: .touchUpInside)
        return button
    }()
    
    private var vStackBottomConstraint = NSLayoutConstraint()
    
    private var loadingIndicator = LoadingDialogView(title: "Signing Up...")
    
    init() {
        super.init(nibName: nil, bundle: nil)
        registerKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.inputField.becomeFirstResponder()
    }
    
    private func setUpViews() {
        self.view.backgroundColor = .white
        setUpNavigation()
        view.addSubview(headingLabel)
        view.addSubview(vStackView)
    }
    
    private func setUpNavigation() {
        let image = UIImage(named: "ic_twitter_logo")
        let imageView = UIImageView(image: image)
        navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.backButtonTitle = "Login"
    }

}

// MARK: Constraints
extension SignUpViewController {
    
    private func setUpConstraints() {
        setUpHeadingLabelConstraints()
        setUpVStackViewConstraints()
        setUpSignUpButtonConstraints()
    }
    
    private func setUpHeadingLabelConstraints() {
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
    }
    
    private func setUpSignUpButtonConstraints() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setUpVStackViewConstraints() {
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        vStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        vStackBottomConstraint = vStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        vStackBottomConstraint.isActive = true
    }
    
}

// MARK: Selectors
extension SignUpViewController {
    
    @objc func didTapOnSignUp() {
        guard let email = emailTextField.inputField.text else {
            showToast(message: "Please enter email")
            return
        }
        
        if (!email.isValidEmail) {
            showToast(message: "Please enter email")
            return
        }
        
        guard let password = passwordInputField.inputField.text else {
            return
        }
        
        if (password.count <= 6) {
            showToast(message: "password length should be greater than 6")
            return
        }
        
        guard let username = userNameField.inputField.text else {
            showToast(message: "Please enter username")
            return
        }
        
        if (password.count <= 2) {
            showToast(message: "Username length should be greater than 3")
            return
        }
        
        guard let fullname = fullNameField.inputField.text else {
            showToast(message: "Please enter full name")
            return
        }
        
        if (password.count <= 2) {
            showToast(message: "Full name length should be greater than 3")
            return
        }
        
        let user = User(username: username, email: email, fullName: fullname, profileUrl: nil)
        
        signningUp(withUser: user, password: password)
    }
    
    
}

// MARK: Services
extension SignUpViewController {
    
    private func signningUp(withUser user: User, password: String) {
        loadingIndicator.show()
        AuthService.shared.registerUser(withUser: user, password: password) { (error) in
            self.handleResponse(error: error)
        }
    }
    
    private func handleResponse(error: Error?) {
        loadingIndicator.dismiss()
        if let error = error {
            showToast(message: error.localizedDescription)
            return
        }
        
        self.dismiss(animated: true, completion: nil)
        guard let window =  UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        guard let feedVC = window.rootViewController as? FeedViewController else {
            return
        }
        feedVC.configureUI()
    }
    
}


// MARK: Delegates
extension SignUpViewController: KeyboardListener {
    
    func keyboardWillShow(height: CGFloat) {
        vStackBottomConstraint.constant = -height
    }
    
    func keyboardWillHide() {
        
    }
    
}
