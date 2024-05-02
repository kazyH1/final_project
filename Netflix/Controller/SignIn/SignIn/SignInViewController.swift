//
//  SignInViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passInput: UITextField!
    @IBOutlet weak var userInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
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
    
}
