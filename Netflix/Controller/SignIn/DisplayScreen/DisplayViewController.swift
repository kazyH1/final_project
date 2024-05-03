//
//  SignInViewController.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import UIKit

class DisplayViewController: UIViewController {
    @IBAction func getStartedButton(_ sender: UIButton) {
        didTabButton(sender)
    }
    
    var onboardingTitle = ["Unlimited movies, TV shows, and more.", "There's a plan for every fan", "Cacel online anytime", "How do I watch?"]
    var onboadingContent = ["""
                            Watch anywhere. Cancel anytime.
                            Let's click Get Started to sign in
                            """,
"Small prince. Big entertaiment.", "Join today, no reason to wait.", "Members that subcribe to Netflix can watch here in the app"]
    
    @IBOutlet weak var onboardingScrollView: UIScrollView!
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    
    lazy var pages: [OnboardingSlideView] = {
            var views = [OnboardingSlideView]()
            if let page1 = Bundle.main.loadNibNamed("OnboardingSlideView", owner: self, options: nil)?.first as? OnboardingSlideView {
                page1.onboardingTitle.text = onboardingTitle[0]
                page1.onboardingContents.text = onboadingContent[0]
                views.append(page1)
            }
            if let page2 = Bundle.main.loadNibNamed("OnboardingSlideView", owner: self, options: nil)?.first as? OnboardingSlideView {
                page2.onboardingTitle.text = onboardingTitle[1]
                page2.onboardingContents.text = onboadingContent[1]
                views.append(page2)
            }
            if let page3 = Bundle.main.loadNibNamed("OnboardingSlideView", owner: self, options: nil)?.first as? OnboardingSlideView {
                page3.onboardingTitle.text = onboardingTitle[2]
                page3.onboardingContents.text = onboadingContent[2]
                views.append(page3)
            }
            if let page4 = Bundle.main.loadNibNamed("OnboardingSlideView", owner: self, options: nil)?.first as? OnboardingSlideView {
                page4.onboardingTitle.text = onboardingTitle[3]
                page4.onboardingContents.text = onboadingContent[3]
                views.append(page4)
            }
            return views
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        setupOnboardingScrollView()
        onboardingPageControl.numberOfPages = pages.count
        onboardingPageControl.currentPage = 0
        onboardingPageControl.isUserInteractionEnabled = false
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action: #selector(didTabButton(_:)))
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func didTabButton(_ button:UIButton){
        let signInVC = SignInViewController()
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func setupOnboardingScrollView() {
        onboardingScrollView.delegate = self
        onboardingScrollView.showsVerticalScrollIndicator = false
        for (index, page) in pages.enumerated() {
            page.frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: onboardingScrollView.frame.height)
            onboardingScrollView.addSubview(page)
        }
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
