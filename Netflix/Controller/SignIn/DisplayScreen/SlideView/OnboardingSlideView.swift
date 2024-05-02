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
        applyContraints(onboardingTitle)
        applyContraints(onboardingContents)
    }
    
    func applyContraints(_ lbl: UILabel){
       let lblConstraints = [
        lbl.widthAnchor.constraint(equalToConstant: self.frame.width)]
        NSLayoutConstraint.activate(lblConstraints)
    }
}
