//
//  LoginViewController.swift
//  Tweety
//
//  Created by Himanshu Arora on 11/04/21.
//

import UIKit
import SuperStackView

class LoginViewController: UIViewController {
    
    private lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.text = "Hey, \nWelcome back"
        label.font = .heavy(size: 48)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var userNameInputField: TweetyInputField = {
        let field = TweetyInputField()
        field.delegate = self
        field.inputField.keyboardType = .emailAddress
        field.inputField.returnKeyType = .next
        field.setPlaceholder(text: "Email")
        return field
    }()
    
    private lazy var passwordInputField: TweetyInputField = {
        let field = TweetyInputField()
        field.inputField.isSecureTextEntry = true
        field.delegate = self
        field.setPlaceholder(text: "Password")
        return field
    }()
    
    private lazy var vStackView: SuperStackView = {
        let stack = SuperStackView()
        stack.stack.axis = .vertical
        stack.hidesSeparatorsByDefault = true
        stack.addRow(userNameInputField)
        stack.addRow(passwordInputField, inset: UIEdgeInsets(top: 24, left: 0, bottom: 2, right: 0))
        stack.addRow(logInButton, inset: UIEdgeInsets(top: 36, left: 0, bottom: 12, right: 0))
        return stack
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = .semibold(size: 16)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .brandBlueColor
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapOnLogInBtn), for: .touchUpInside)
        return button
    }()
    
    private var signUpBottomConstraint = NSLayoutConstraint()
    
    private var loadingIndicator = LoadingDialogView(title: "Authenticating...")
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "Click here to sign up"
        label.font = .semibold(size: 14)
        label.textColor = .black
        return label
    }()
    
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
        userNameInputField.inputField.becomeFirstResponder()
    }
    
    private func setUpViews() {
        self.view.backgroundColor = .white
        
        setUpNavigation()
        
        view.addSubview(headingLabel)
        view.addSubview(vStackView)
        
        setUpSignUpLabel()
    }
    
    private func setUpNavigation() {
        let image = UIImage(named: "ic_twitter_logo")
        let imageView = UIImageView(image: image)
        navigationItem.titleView = imageView
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.backButtonTitle = "Login"
    }
    
    private func setUpSignUpLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnSignUp))
        signUpLabel.addGestureRecognizer(tap)
        self.view.addSubview(signUpLabel)
    }
        

}

// MARK: Constraints
extension LoginViewController {
    
    private func setUpConstraints() {
        setUpHeadingLabelConstraints()
        setUpVStackViewConstraints()
        setUpLogInButtonConstraints()
        setUpSignUpLabelConstraints()
    }
    
    private func setUpHeadingLabelConstraints() {
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
    }
    
    private func setUpLogInButtonConstraints() {
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setUpVStackViewConstraints() {
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        vStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        vStackView.bottomAnchor.constraint(equalTo: signUpLabel.topAnchor, constant: -24).isActive = true
    }
    
    private func setUpSignUpLabelConstraints() {
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        signUpLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        signUpBottomConstraint = signUpLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                            constant: -12)
        signUpBottomConstraint.isActive = true
    }
    
}


// MARK: Selectors
extension LoginViewController {
    
    @objc func didTapOnLogInBtn() {
        guard let email = userNameInputField.inputField.text, !email.isEmpty else {
            showToast(message: "Please enter email")
            return
        }
        if (!email.isValidEmail) {
            showToast(message: "Please enter valid email")
            return
        }
        guard let password = passwordInputField.inputField.text, !password.isEmpty else {
            showToast(message: "Please enter password")
            return
        }
        if (password.count <= 6) {
            showToast(message: "password length should be greater than 6")
            return
        }
        
        loggingIn(withEmail: email, password: password)
    }
    
    @objc func didTapOnSignUp() {
//        let vc = SignUpViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: Services
extension LoginViewController {
    
    private func loggingIn(withEmail email: String, password: String) {
        loadingIndicator.show()
        AuthService.shared.signIn(with: email, password: password) { (error) in
            self.handleResponse(error: error)
        }
    }
    
    private func handleResponse(error: Error?) {
        loadingIndicator.dismiss(animated: true)
        if let error = error {
            print(error)
            showToast(message: error.localizedDescription)
        }
        
        // now success
    }
    
}


// MARK: Delegates
extension LoginViewController: KeyboardListener {
    
    func keyboardWillShow(height: CGFloat) {
        signUpBottomConstraint.constant = -height
    }
    
    func keyboardWillHide() {
        signUpBottomConstraint.constant = -12
    }
    
}

extension LoginViewController: TweetyInputFieldDelegate {
    
    func textFieldShouldReturn(_ inputView: TweetyInputField) -> Bool {
        if (inputView == userNameInputField) {
            passwordInputField.inputField.becomeFirstResponder()
        }
        return true
    }
    
    
}
