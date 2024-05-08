//
//  OnboardingViewController.swift
//  Netflix
//
//  Created by Admin on 08/05/2024.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var onboardingTitleLabel: UILabel!
    @IBOutlet weak var onboardingContentsLabel: UILabel!
    
    private let viewModel: OnboardingSlideViewModel
    
    // MARK: - Initializers
    init(viewModel: OnboardingSlideViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyContraints(onboardingTitleLabel)
        applyContraints(onboardingContentsLabel)
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    func applyContraints(_ lbl: UILabel){
        let lblConstraints = [
            lbl.widthAnchor.constraint(equalToConstant: view.frame.width)]
        NSLayoutConstraint.activate(lblConstraints)
    }
    private func bindViewModel() {
        onboardingTitleLabel.text = viewModel.onboardingSlide.title
        onboardingContentsLabel.text = viewModel.onboardingSlide.content
        
    }
}
