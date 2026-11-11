//
//  ContentView.swift
//  HelloStepCounter
//
//  Created by Mohammad Azam on 4/15/25.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    @State private var healthManager = HealthManager()
    @State private var message: String = ""
    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    @State private var endDate: Date = Date()
    
    @State private var lastKnownAuthorizationStatus: HKAuthorizationStatus?
    
    private func handleHealthDataAuthorization() async throws {
        
        lastKnownAuthorizationStatus = healthManager.checkAuthorizationStatus(for: .stepCount)
        switch lastKnownAuthorizationStatus {
            case .notDetermined:
                try await healthManager.requestAuthorization()
                
                // check the authorization status
                let newStatus = healthManager.checkAuthorizationStatus(for: .stepCount)
                if newStatus == .sharingAuthorized {
                    message = "Permission granted."
                    healthManager.fetchSteps(start: startDate, end: endDate)
                } else {
                    message = "Permission not granted."
                }
            case .sharingDenied:
                message = "Permission denied – can't access step data."
            case .sharingAuthorized:
                message = "Permission granted – loading step data..."
                healthManager.fetchSteps(start: startDate, end: endDate)
            case .none:
                message = "Unable to determine HealthKit status."
            @unknown default:
                message = "Unknown HealthKit status."
        }
        
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Step Count")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text("\(healthManager.stepCount)")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.green)
            
            if !message.isEmpty && healthManager.stepCount == 0 {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            
            Divider().padding(.vertical)
            
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
            
            Button("Fetch Steps") {
                healthManager.fetchSteps(start: startDate, end: endDate)
            }.buttonStyle(.borderedProminent)
                .padding(.top)
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { _ in
            
            Task {
                
                let currentStatus = healthManager.checkAuthorizationStatus(for: .stepCount)
                if currentStatus != lastKnownAuthorizationStatus {
                    lastKnownAuthorizationStatus = currentStatus
                    try await handleHealthDataAuthorization()
                }
            }
            
        })
        .task {
            do {
                try await handleHealthDataAuthorization()
            } catch {
                print(error.localizedDescription)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
