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
    
    var pages : [OnboardingSlideView] {
        get {
            let page1: OnboardingSlideView = Bundle.main.loadNibNamed("OnboardingSlideView", owner: self, options: nil)?.first as! OnboardingSlideView
            page1.onboardingTitle.text = onboardingTitle[0]
            page1.onboardingContents.text = onboadingContent[0]
            let page2: OnboardingSlideView = Bundle.main.loadNibNamed("OnboardingSlideView", owner: self, options: nil)?.first as! OnboardingSlideView
            page2.onboardingTitle.text = onboardingTitle[1]
            page2.onboardingContents.text = onboadingContent[1]
            let page3: OnboardingSlideView = Bundle.main.loadNibNamed("OnboardingSlideView", owner: self, options: nil)?.first as! OnboardingSlideView
            page3.onboardingTitle.text = onboardingTitle[2]
            page3.onboardingContents.text = onboadingContent[2]
            let page4: OnboardingSlideView = Bundle.main.loadNibNamed("OnboardingSlideView", owner: self, options: nil)?.first as! OnboardingSlideView
            page4.onboardingTitle.text = onboardingTitle[3]
            page4.onboardingContents.text = onboadingContent[3]
            return [page1, page2, page3, page4]
        }
    }
    
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
