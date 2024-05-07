//
//  SignInViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit

class DisplayViewController: UIViewController {
    
    private var viewModel = DisplayViewModel()
      private var onboardingSlideViewModels: [OnboardingSlideViewModel] {
          return viewModel.onboardingSlides
      }
      
      lazy var pages: [OnboardingSlideView] = {
          var views = [OnboardingSlideView]()
          for slideViewModel in onboardingSlideViewModels {
              let slideView = OnboardingSlideView()
              slideView.configure(with: slideViewModel)
              views.append(slideView)
          }
          return views
      }()
    
    @IBOutlet weak var onboardingScrollView: UIScrollView!
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        setupOnboardingScrollView()
        onboardingPageControl.numberOfPages = pages.count
        onboardingPageControl.currentPage = 0
        onboardingPageControl.isUserInteractionEnabled = false
        print("onboardingSlides:", viewModel.onboardingSlides)
    }
    
    @IBAction func getStartedButton(_ sender: UIButton) {
        didTabButton(sender)
    }
}
    
extension DisplayViewController {
    
    @objc func didTabButton(_ button:UIButton){
        let signInVC = SignInViewController()
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action: #selector(didTabButton(_:)))
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupOnboardingScrollView() {
        onboardingScrollView.delegate = self
        onboardingScrollView.showsVerticalScrollIndicator = false
        
        // Xóa các subviews cũ trước khi thêm mới
        for subview in onboardingScrollView.subviews {
            subview.removeFromSuperview()
        }
        
        // Thêm các OnboardingSlideView vào onboardingScrollView
        for (index, page) in pages.enumerated() {
            page.frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: onboardingScrollView.frame.height)
            onboardingScrollView.addSubview(page)
        }
        
        // Cập nhật lại contentSize của onboardingScrollView
        onboardingScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pages.count), height: onboardingScrollView.frame.height)
    }
}

extension DisplayViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        onboardingPageControl.currentPage = Int(pageIndex)
        if onboardingScrollView.contentOffset.y > 0 || onboardingScrollView.contentOffset.y < 0 {
            onboardingScrollView.contentOffset.y = 0
        }
    }
}
