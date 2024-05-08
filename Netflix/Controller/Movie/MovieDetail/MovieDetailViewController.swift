//
//  MovieDetailViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var detailView: UIView!
    
    private var categoryTabBarController = CategoryTabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureOnboardingSlides()
    }
    
    private func configureOnboardingSlides() {
           // Sử dụng thể hiện categoryTabBarController đã được khai báo
           detailView.addSubview(categoryTabBarController.view)
           // Đảm bảo rằng child view controller được thêm vào và cập nhật frames nếu cần
           categoryTabBarController.view.frame = detailView.bounds
           addChild(categoryTabBarController)
           categoryTabBarController.didMove(toParent: self)
       }
}
