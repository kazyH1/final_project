//
//  SceneDelegate.swift
//  Netflix
//
//  Created by Admin on 11/04/2024.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        if let currentUser = Auth.auth().currentUser {
            let tabBarVC = TabBarViewController()
            let tabBarNavi = UINavigationController(rootViewController: tabBarVC)
            window?.windowScene = windowScene
            window?.rootViewController = tabBarNavi
        } else {
            let displayVC = DisplayViewController()
            let displayNavi = UINavigationController(rootViewController: displayVC)
            window?.rootViewController = displayNavi
            window?.windowScene = windowScene
        }
        //        let tabBarVC = MovieDetailViewController()
        //        let tabBarNavi = UINavigationController(rootViewController: tabBarVC)
        //        window?.windowScene = windowScene
        //        window?.rootViewController = tabBarNavi
        window?.makeKeyAndVisible()
        if let urlContext = connectionOptions.urlContexts.first, let currentUser1 = Auth.auth().currentUser {
            handleDeepLink(url: urlContext.url)
        } else if let urlContext = connectionOptions.urlContexts.first {
            let alert = UIAlertController(title: "Please Sign In", message: "You need to be logged in to watch movies.", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { [weak self] _ in
                    guard let self = self else { return }
                    let signInVC = SignInViewController()
                    let signInNavi = UINavigationController(rootViewController: signInVC)
                    self.window?.rootViewController = signInNavi
                  }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            window?.rootViewController?.present(alert, animated: true)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            handleDeepLink(url: url)
        }
    }
    
    private func handleDeepLink(url: URL) {
        let urlString = url.absoluteString
        let components = urlString.components(separatedBy: "=")
        if components.count > 1, let movieIdString = components.last, let movieId = Int(movieIdString) {
            // Create an instance of MovieDetailViewController and push it
            if let navigationController = window?.rootViewController as? UINavigationController {
                let movieDetailVC = MovieDetailViewController()
                let movie = Movie(id: movieId, key: nil, media_type: nil, original_name: nil, original_title: nil, poster_path: nil, backdrop_path: nil, overview: nil, vote_count: 0, release_date: nil, vote_average: 0.0)
                movieDetailVC.movie = movie
                navigationController.pushViewController(movieDetailVC, animated: true)
            }
        }
    }
}

