//
//  OnboardingState.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import Foundation

enum onboardingState {
    case sendToDashboard
    case sendToOnboarding
}


func checkOnboardingState() -> onboardingState {
    
    if (userDefaults?.object(forKey: "onboardingState") as? Int) != nil {
        return .sendToDashboard
    } else {
        return .sendToOnboarding
    }
    
}
