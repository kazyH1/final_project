//
//  CategoryTabBar.swift
//  Netflix
//
//  Created by Admin on 08/05/2024.
//

import Foundation
import Tabman
import Pageboy

class CategoryTabBarController: TabmanViewController {
    private var viewControllers = [EpisodesViewController(), MoreLikeThisTableViewController()]
    
    private var titleViewController = ["Episodes","More like this"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

