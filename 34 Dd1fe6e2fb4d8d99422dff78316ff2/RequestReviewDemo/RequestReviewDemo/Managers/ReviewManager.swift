//
//  ReviewManager.swift
//  RequestReviewDemo
//
//  Created by Mohammad Azam on 12/2/25.
//

import Foundation

enum ReviewCriteria {
    case launch
    case delay(seconds: TimeInterval)
}

struct ReviewManager {
    
    private let minLaunchCount = 7
    private let hasRequestedKey = "hasRequestedReview"
    private let launchCountKey = "launchCount"
    
    func requestReviewIfNeeded(criteria: ReviewCriteria, requestReview: @escaping () -> Void) {
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: hasRequestedKey) { return }
        
        switch criteria {
            case .launch:
            let newLaunchCount = defaults.integer(forKey: launchCountKey) + 1
            defaults.set(newLaunchCount, forKey: launchCountKey)
            
            guard newLaunchCount >= minLaunchCount else { return }
            requestReview()
            defaults.set(true, forKey: hasRequestedKey)
            
            case .delay(let seconds):
            Task {
                try? await Task.sleep(for: .seconds(seconds))
                if !defaults.bool(forKey: hasRequestedKey) {
                    requestReview()
                    defaults.set(true, forKey: hasRequestedKey)
                }
            }
        }
        
    }
    
}
