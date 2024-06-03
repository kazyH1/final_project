//
//  BaseViewController.swift
//  Netflix
//
//  Created by HuyNguyen on 09/05/2024.
//

import UIKit
import FirebaseAuth

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: #selector(pushUserManagerment))
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    @objc func pushUserManagerment() {
        let userManagementViewController = UserManagementViewController()
        navigationController?.pushViewController(userManagementViewController, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
