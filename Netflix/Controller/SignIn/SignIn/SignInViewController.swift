//
//  SignInViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit
//import FirebaseDatabase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    let signInViewModel = SignInViewModel.shared
    
    @IBAction func passwordSecureButton(_ sender: UIButton) {
        if !passwordTextField.isSecureTextEntry{
            sender.setTitle("SHOW", for: .normal)
        } else {
            sender.setTitle("HIDE", for: .normal)
        }
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        signIn(email: email, password: password)
    }
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        designPlaceholder(emailTextField, playholderText: "Email or phone number")
        designPlaceholder(passwordTextField, playholderText: "Password")
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTextField()
        setupInfoLabel(emailTextField, lbl: emailLabel)
        setupInfoLabel(passwordTextField, lbl: passLabel)
    }
    
    func setupInfoLabel(_ tf: UITextField, lbl: UILabel) {
        lbl.isHidden = !tf.hasText
    }
    
    func setupTextField() {
        emailTextField.addTarget(self, action: #selector(checkFormatEmailAndPass), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(checkFormatEmailAndPass), for: .editingChanged)
    }
    
    @objc func checkFormatEmailAndPass() {
        guard let email = emailTextField.text, let pass = passwordTextField.text else { return }
        signInButton.isEnabled = email.isValidEmail(email) && pass.isValidPassword(pass)
    }
    
    private func designPlaceholder(_ tf: UITextField, playholderText: String) {
        tf.attributedPlaceholder = NSAttributedString(string: playholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
    }
    
    
    
    private func configureNavbar() {
        let yourBackImage = UIImage(systemName: "arrow.backward")
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: yourBackImage, style: .done, target: self, action: #selector(backPreviousScreen))
                                             ,UIBarButtonItem(image: image, style: .done, target: self, action: nil)]
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func backPreviousScreen(){
        self.navigationController?.popViewController(animated: true)
//        let displayVC = DisplayViewController()
//        self.navigationController?.pushViewController(displayVC, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func signIn(email: String, password: String) {
        Task {
            do {
                try await signInViewModel.signIn(email: email, pass: password)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let tabBarViewControlller = TabBarViewController()
                    self.navigationController?.setViewControllers([tabBarViewControlller], animated: true)
                    self.navigationController?.navigationBar.isHidden = true
                }
            } catch let error as SignInViewModel.AuthError {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.handleAuthError(error)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let message = "There was an error: \(error.localizedDescription)"
                    self.showAlert(title: "Login fail", message: message)
                }
            }
        }
    }
    
    func handleAuthError(_ error: SignInViewModel.AuthError) {
        switch error {
        case .wrongPassword:
            showAlert(title: "Login fail", message: "Wrong password.")
        case .userNotFound:
            showAlert(title: "Login fail", message: "User not found.")
        case .unknownError:
            showAlert(title: "Login fail", message: "Email or password is invalid!.")
        }
    }
}

class CustomNavigationController: UINavigationController {

    override func popViewController(animated: Bool) -> UIViewController? {
        // Ngăn chặn hành vi pop mặc định cho các view controller con
        return nil
    }
}
