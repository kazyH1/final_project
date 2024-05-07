//
//  DisplayViewModel.swift
//  Netflix
//
//  Created by Admin on 07/05/2024.
//

import Foundation

class DisplayViewModel {
    let onboardingSlides: [OnboardingSlideViewModel] = [
        OnboardingSlideViewModel(title: "Unlimited movies, TV shows, and more.", content: """
                                    Watch anywhere. Cancel anytime.
                                    Let's click Get Started to sign in
                                    """),
        OnboardingSlideViewModel(title: "There's a plan for every fan", content: "Small prince. Big entertaiment."),
        OnboardingSlideViewModel(title: "Cancel online anytime", content: "Join today, no reason to wait."),
        OnboardingSlideViewModel(title: "How do I watch?", content: "Members that subcribe to Netflix can watch here in the app")
    ]
}

