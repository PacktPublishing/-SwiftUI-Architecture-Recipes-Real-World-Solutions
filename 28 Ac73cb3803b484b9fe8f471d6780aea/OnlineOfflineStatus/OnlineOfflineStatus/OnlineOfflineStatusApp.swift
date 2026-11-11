//
//  OnlineOfflineStatusApp.swift
//  OnlineOfflineStatus
//
//  Created by Mohammad Azam on 7/6/26.
//

import SwiftUI

@main
struct OnlineOfflineStatusApp: App {
    
    @State private var networkStatusManager = NetworkStatusManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }.overlay(alignment: .topLeading) {
                NetworkStatusView(networkStatusManager: networkStatusManager)
                    .padding() 
            }
        }
    }
}
