//
//  SignInViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit

class DisplayViewController: UIViewController {
    
    
    @IBOutlet weak var onboardingScrollView: UIScrollView!
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    
    // MARK: - Properties
    private var viewModel = DisplayViewModel()
    private var onboardingSlideVC: [OnboardingViewController] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        bindViewModel()
        configureOnboardingSlides()
        configureNavbar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func getStartedButton(_ sender: UIButton) {
        didTapButton(sender)
    }
}
    
// MARK: - Helper Methods
extension DisplayViewController {
    
    private func bindViewModel() {
        viewModel.fetchSlides()
    }
    
    @objc func didTapButton(_ button: UIButton) {
        let signInVC = SignInViewController()
        self.navigationController?.pushViewController(signInVC, animated: true)
        
        //test user info view
//        let viewController = UserInfoViewController()
//        navigationController?.setViewControllers([viewController], animated: true)
//        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureNavbar() {
        let image = UIImage(named: "netflixLogo")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureOnboardingSlides() {
        for (index, onboardingSlide) in viewModel.onboardingSlides.enumerated() {
            let slideView = OnboardingViewController(viewModel: OnboardingSlideViewModel(onboardingSlide: onboardingSlide))
            slideView.view.frame = CGRect(x: CGFloat(index) * (view.frame.width + 20 + CGFloat(index + 3) * 3) , y: 0, width: view.frame.width, height: view.frame.height)
            addChild(slideView)
            onboardingScrollView.addSubview(slideView.view)
            slideView.didMove(toParent: self)
        }
        onboardingScrollView.translatesAutoresizingMaskIntoConstraints = false
        onboardingScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(viewModel.onboardingSlides.count) + 500, height: view.frame.height)
        onboardingScrollView.isPagingEnabled = true
        onboardingScrollView.showsHorizontalScrollIndicator = false
        onboardingScrollView.delegate = self
        onboardingPageControl.numberOfPages = viewModel.onboardingSlides.count
        onboardingPageControl.currentPage = 0
        onboardingPageControl.isUserInteractionEnabled = false
    }
}



// MARK: - UIScrollViewDelegate
extension DisplayViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        onboardingPageControl.currentPage = Int(pageIndex)
        if onboardingScrollView.contentOffset.y > 0 || onboardingScrollView.contentOffset.y < 0 {
            onboardingScrollView.contentOffset.y = 0
        }
    }
}
