//
//  CategoryTabBar.swift
//  Netflix
//
//  Created by Admin on 08/05/2024.
//

import Foundation
import Tabman
import Pageboy
import SwiftEventBus

class CategoryTabBarController: TabmanViewController {
    private var viewControllers = [EpisodesViewController(), CollectionViewController(), MoreLikeThisViewController(), TrailersMoreViewController()]
    
    private var titleViewController = ["Episodes","Collection","More like this", "Trailers & More"]
    
    var movieDetails : MovieDetailResponse? = nil
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        SwiftEventBus.unregister(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftEventBus.onMainThread(self, name: "updateCategoryTab") { result in
            self.movieDetails = result?.object as? MovieDetailResponse
             }
        self.dataSource = self
        // Create bar
        setupBar()
    }
    
    func setupBar() {
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.backgroundView.style = .flat(color: .black)
        // Add to view
        addBar(bar, dataSource: self, at: .top)
        bar.indicator.tintColor = UIColor(red: 200/255, green: 25/255, blue: 3/255, alpha: 1)
        bar.buttons.customize { (button) in
            button.tintColor = .gray
            button.selectedTintColor = UIColor.white
        }
    }
}

extension CategoryTabBarController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(1000), execute: {
            SwiftEventBus.post("updateCategoryTab", sender: self.movieDetails)
        })
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = titleViewController[index]
        return TMBarItem(title: title)
    }
}

