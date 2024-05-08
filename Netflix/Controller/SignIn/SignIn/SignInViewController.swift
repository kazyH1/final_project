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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
    }
    
    // MARK: - Actions
    @IBAction func passwordSecureButton(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let title = passwordTextField.isSecureTextEntry ? "SHOW" : "HIDE"
        sender.setTitle(title, for: .normal)
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
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
    }
    
    private func designPlaceholder(_ textField: UITextField, placeholderText: String, label: UILabel) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        label.isHidden = !textField.hasText
    }
    
    private func configureNavbar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backPreviousScreen))
        let logoImage = UIImage(named: "netflixLogo")?.withRenderingMode(.alwaysOriginal)
        let logoButton = UIBarButtonItem(image: logoImage, style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItems = [backButton, logoButton]
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
        let tabBarViewController = TabBarViewController()
        navigationController?.setViewControllers([tabBarViewController], animated: true)
        navigationController?.navigationBar.isHidden = true
    }
    
    func signInFailure(with error: String) {
        showAlert(title: "Login fail", message: error)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

