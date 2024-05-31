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
    
    @IBAction func signOut(_ sender: Any) {
        NetworkManager.shared.logOut()
        let displayVC = DisplayViewController()
        let navigationController = UINavigationController(rootViewController: displayVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
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
        
        members = Member.getMembers() ?? []
        
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
    
    
    @objc private func handleBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
    }
    
    @IBAction func logout(_ sender: Any) {
        let displayVC = DisplayViewController()
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        navigationController?.pushViewController(displayVC, animated: true)
    }
    
}


extension UserManagementViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        Member.saveCurrentMembers(member: members[indexPath.row])
        //update
        SwiftEventBus.post("AddToMyList")
        SwiftEventBus.postToMainThread("ReloadHomeView")
        self.navigationController?.popViewController(animated: true)
    }
}

