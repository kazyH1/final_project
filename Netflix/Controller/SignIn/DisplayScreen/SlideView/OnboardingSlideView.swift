//
//  OnboardingSlideView.swift
//  Netflix
//
//  Created by Admin on 02/05/2024.
//

import UIKit

class OnboardingSlideView: UIView {
    
    @IBOutlet weak var onboardingTitle: UILabel!
    @IBOutlet weak var onboardingContents: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        super.layoutSubviews()
        if let titleLabel = onboardingTitle {
            applyContraints(titleLabel)
        }
        if let contentsLabel = onboardingContents {
            applyContraints(contentsLabel)
        }
    }
    
    func applyContraints(_ lbl: UILabel){
        let lblConstraints = [
            lbl.widthAnchor.constraint(equalToConstant: self.frame.width)]
        NSLayoutConstraint.activate(lblConstraints)
    }
    func configure(with viewModel: OnboardingSlideViewModel) {
        guard let titleLabel = onboardingTitle else {
            print("Error: titleLabel is nil.")
            return
        }
        onboardingTitle.text = viewModel.title
        onboardingContents.text = viewModel.content
    }
}
