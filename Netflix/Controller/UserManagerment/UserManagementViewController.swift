//
//  UserManagementViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit
import SwiftEventBus

class UserManagementViewController: BaseViewController {
    
    var members: [Member] = [Member]()
    var viewModel: UserManagementViewModel?
    private let backButton = UIButton(type: .system)
    
    @IBAction func openMyList(_ sender: Any) {
        let mylistVC = MyListViewController()
        navigationController?.pushViewController(mylistVC, animated: true)
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Sign out", message: "Are you sure to sign out?", preferredStyle: .alert)
        
        // Sign-out confirmation
        let signOutAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.handleSignOut()
        }
        alertController.addAction(signOutAction)
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func handleSignOut() {
        NetworkManager.shared.logOut()
        
        // Resetting the root view controller to DisplayViewController after sign-out
        let displayVC = DisplayViewController()
        let navigationController = UINavigationController(rootViewController: displayVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = UserManagementViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        
        // basic setup
        view.backgroundColor = .black
        
        // button customization
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Profile & More", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        backButton.titleLabel?.textColor = .white
        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    func configureNavigation() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .black
        navBarAppearance.shadowColor = nil
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveCurrentUserToFirst()
        view.backgroundColor = .black
        
        //show back button
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, view.safeAreaInsets.top))
        
        //setup back button
        initialSetup()
        
        configureNavigation()
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(userInfoCollectionView)
        
        userInfoCollectionView.backgroundColor = .black
        
        userInfoCollectionView.delegate = self
        userInfoCollectionView.dataSource = self
        userInfoCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
    }
    
    public let userInfoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 150), collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
        collectionView.register(UserInfoCollectionViewCell.self, forCellWithReuseIdentifier: UserInfoCollectionViewCell.identifier)
        return collectionView
        
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userInfoCollectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 150)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func handleBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
        
    private func moveCurrentUserToFirst() {
        members = Member.getMembers() ?? []
        
        if let currentUser = Member.getCurrentMembers() {
            if let index = members.firstIndex(where: { $0.id == currentUser.id }) {
                let currentUser = members.remove(at: index)
                members.insert(currentUser, at: 0)
            }
        }
    }
}


extension UserManagementViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCollectionViewCell.identifier, for: indexPath) as? UserInfoCollectionViewCell else {return UICollectionViewCell()}
        
        let member = members[indexPath.row]
        cell.configure(with: member)
        
        if let currentUser = Member.getCurrentMembers(), currentUser.id == member.id {
            cell.titleLabel.textColor = .green
        } else {
            cell.titleLabel.text = member.name
        }
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //navigate to user management
        Member.saveCurrentMembers(member: members[indexPath.row])
        //update
        SwiftEventBus.post("AddToMyList")
        SwiftEventBus.postToMainThread("ReloadHomeView")
        navigationController?.popViewController(animated: true)
    }
}

