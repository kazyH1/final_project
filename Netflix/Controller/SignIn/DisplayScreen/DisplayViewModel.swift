//
//  DisplayViewModel.swift
//  Netflix
//
//  Created by Admin on 07/05/2024.
//

import Foundation

class DisplayViewModel {
    var onboardingSlides = [OnboardingSlide]()
    
    func fetchSlides() {
        onboardingSlides = [
            OnboardingSlide(title: "Unlimited movies, TV shows, and more.", content: """
                                                        Watch anywhere. Cancel anytime.
                                                        Let's click Get Started to sign in
                                                        """),
            OnboardingSlide(title: "There's a plan for every fan", content: "Small prince. Big entertainment."),
            OnboardingSlide(title: "Cancel online anytime", content: "Join today, no reason to wait."),
            OnboardingSlide(title: "How do I watch?", content: "Members that subscribe to Netflix can watch here in the app")
        ]
    }
}
