//
//  HealthManager.swift
//  HelloStepCounter
//
//  Created by Mohammad Azam on 4/15/25.
//

import Foundation
import HealthKit
import Observation


@Observable
class HealthManager {
    
    private let healthStore = HKHealthStore()
    var stepCount = 0
    
    func checkAuthorizationStatus(for identifier: HKQuantityTypeIdentifier) -> HKAuthorizationStatus {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else { return .notDetermined }
        return healthStore.authorizationStatus(for: quantityType)
    }
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        try await healthStore.requestAuthorization(toShare: [stepType], read: [stepType])
    }
    
    func fetchSteps(start: Date, end: Date) {
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            
            DispatchQueue.main.async {
                if let quantity = result?.sumQuantity() {
                    let steps = Int(quantity.doubleValue(for: HKUnit.count()))
                    self.stepCount = steps
                }
            }
            
        }
        
        healthStore.execute(query)
    }
    
}
