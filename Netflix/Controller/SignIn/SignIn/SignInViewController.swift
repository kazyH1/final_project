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
        if passwordTextField.isSecureTextEntry{
            
        }
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        didTabButton(sender)
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
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
