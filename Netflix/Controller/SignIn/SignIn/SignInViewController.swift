//
//  SignInViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - Properties
    private var viewModel: SignInViewModel?
    
    // MARK: - Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = SignInViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    // MARK: - Actions
    @IBAction func passwordSecureButton(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let title = passwordTextField.isSecureTextEntry ? "SHOW" : "HIDE"
        sender.setTitle(title, for: .normal)
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        self.showSpinner(onView: self.view)
        viewModel?.signIn(email: email, pass: password)
    }
}
// MARK: - UI Configuration
extension SignInViewController {
    
    private func configureUI() {
        emailTextField.addTarget(self, action: #selector(checkFormatEmailAndPass), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(checkFormatEmailAndPass), for: .editingChanged)
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        designPlaceholder(emailTextField, placeholderText: "Email or phone number", label: emailLabel)
        designPlaceholder(passwordTextField, placeholderText: "Password", label: passLabel)
        configureNavbar()
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.layer.borderWidth = 1
        signInButton.layer.cornerRadius = 5.0
        signInButton.layer.masksToBounds = true
    }
    
    private func designPlaceholder(_ textField: UITextField, placeholderText: String, label: UILabel) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        label.isHidden = !textField.hasText
    }
    
    private func configureNavbar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.titleLabel?.textColor = .black
        backButton.addTarget(self, action: #selector(backPreviousScreen), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        
        let logoImage = UIImage(named: "netflixLogo")?.withRenderingMode(.alwaysOriginal)
        let logoButton = UIBarButtonItem(image: logoImage, style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItems = [backButtonItem, logoButton]
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
}

// MARK: - Helper Methods
extension SignInViewController {
    @objc func checkFormatEmailAndPass() {
        guard let email = emailTextField.text, let pass = passwordTextField.text else { return }
        signInButton.isEnabled = email.isValidEmail(email) && pass.isValidPassword(pass)
    }
    
    @objc func backPreviousScreen() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Helper Methods
extension SignInViewController: SignInViewModelDelegate {
    
    func signInSuccess() {
        DispatchQueue.main.async {
            self.removeSpinner()
            let userInfoVC = UserInfoViewController()
            self.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
    
    func signInFailure(with error: String) {
        DispatchQueue.main.async {
            self.removeSpinner()
            self.showAlert(title: "Login fail", message: error)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
