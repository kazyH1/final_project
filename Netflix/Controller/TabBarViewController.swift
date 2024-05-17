//
//  TabBarViewController.swift
//  Netflix
//
//  Created by Admin on 15/04/2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        creatTab()
        setLayout()
        hideBackButton()
    }
    
    private func setLayout() {
        tabBar.barTintColor = .black
        tabBar.tintColor = .white
    }
    private func creatTab() {
        let homeNavi = setupNavigationController(rootViewController: HomeViewController(), tabBarImage: "homeIcon")
        let newHotNavi = setupNavigationController(rootViewController: NewAndHotViewController(), tabBarImage: "playStackIcon")
        let searchNavi = setupNavigationController(rootViewController: SearchViewController(), tabBarImage: "searchIcon")
        let fastLaughsNavi = setupNavigationController(rootViewController: FastLaughsViewController(), tabBarImage: "smileIcon")
        let myListNavi = setupNavigationController(rootViewController: MyListViewController(), tabBarImage: "List")
//        let downloadNavi = setupNavigationController(rootViewController: DownloadViewController(), tabBarImage: "downloadIcon")
        setViewControllers([homeNavi, newHotNavi, fastLaughsNavi, searchNavi, myListNavi], animated: true)
    }
    
    private func setupNavigationController(rootViewController: UIViewController, tabBarImage: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = UIImage(named: tabBarImage)
        return navigationController
    }
    private func hideBackButton() {
        navigationController?.navigationBar.isHidden = true
    }
}

