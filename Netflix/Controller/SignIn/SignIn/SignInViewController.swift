//
//  SignInViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit
//import FirebaseDatabase
//import FirebaseAuth

class SignInViewController: UIViewController {
    
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
        didTabButton(sender)
    }
    
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        designPlaceholder(emailTextField, playholderText: "Email or phone number")
        designPlaceholder(passwordTextField, playholderText: "Password")
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPlaceholder(emailTextField, lbl: emailLabel)
        setupPlaceholder(passwordTextField, lbl: passLabel)
    }
    
    func setupPlaceholder(_ tf: UITextField, lbl: UILabel) {
        if !tf.hasText {
            lbl.isHidden = true
        } else {
            lbl.isHidden = false
        }
    }
    
    func designPlaceholder(_ tf: UITextField, playholderText: String) {
        tf.attributedPlaceholder = NSAttributedString(string: playholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
    }
    
    @objc func didTabButton(_ button:UIButton){
        let homeVC = HomeViewController()
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    private func configureNavbar() {
        let yourBackImage = UIImage(systemName: "arrow.backward")
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: yourBackImage, style: .done, target: self, action: #selector(backBarButtonTapped))
                                             ,UIBarButtonItem(image: image, style: .done, target: self, action: nil)]
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func backBarButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
//    private func userExists() -> Bool {
//        if let currentUser = Auth.auth().currentUser {
//            // Người dùng đã đăng nhập
//            completion(true)
//        } else {
//            // Không có người dùng nào đang đăng nhập
//            completion(false)
//        }
//    }
//    
}
