//
//  UserInfoController.swift
//  Netflix
//
//
//

import Foundation
import UIKit
import SwiftEventBus
protocol UserInfoViewControllerDelegate: AnyObject {
    func userInfoViewControllerDidItemTap()
}

class UserInfoViewController: UIViewController {
    
    var members: [Member] = [Member]()
    private var collectionView: UICollectionView!
    var heightLabelReadMore : CGFloat = 120.0
    var movie: Movie?
    private let backButton = UIButton(type: .system)
    
    public weak var delegate: UserInfoViewControllerDelegate?
    
    public let userInfoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 110, height: UIScreen.main.bounds.width / 2 - 110)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 100
        layout.collectionView?.backgroundColor = .black
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserInfoCollectionViewCell.self, forCellWithReuseIdentifier: UserInfoCollectionViewCell.identifier)
        return collectionView
        
    }()
    
    
    private func initialSetup() {
        
        // basic setup
        view.backgroundColor = .black
        
        // button customization
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        backButton.titleLabel?.textColor = .white
        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc private func handleBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
    }
    
    func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = .black
        navBarAppearance.shadowColor = nil
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        members = Member.getMembers() ?? []
        
        //setup back button
        initialSetup()
        
        title = "Who's watching?"
        configureNavigation()
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(titleLabel)
        
        view.addSubview(userInfoCollectionView)
        
        userInfoCollectionView.backgroundColor = .black
        
        userInfoCollectionView.delegate = self
        userInfoCollectionView.dataSource = self
        userInfoCollectionView.contentInset = UIEdgeInsets(top: 150, left: 60, bottom: 10, right: 60)
        
       
        
    }
    
    private let titleLabel : UILabel = {
       let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Who's watching?"
        title.textColor = .white
        title.backgroundColor = .blue
        return title
    }()
    
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userInfoCollectionView.frame = view.bounds
        
        titleLabel.bottomAnchor.constraint(equalTo: userInfoCollectionView.topAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: userInfoCollectionView.centerXAnchor, constant: 0).isActive = true
        titleLabel.sizeToFit()
    }

}

extension UserInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCollectionViewCell.identifier, for: indexPath) as? UserInfoCollectionViewCell else {return UICollectionViewCell()}
        
        cell.configure(with: members[indexPath.row])
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //navigate to user management
        let tabbarVC = TabBarViewController()
        navigationController?.setViewControllers([tabbarVC], animated: true)
        Member.saveCurrentMembers(member: members[indexPath.row])
        //update mylist
        SwiftEventBus.post("AddToMyList")
        navigationController?.navigationBar.isHidden = true
    }
}
