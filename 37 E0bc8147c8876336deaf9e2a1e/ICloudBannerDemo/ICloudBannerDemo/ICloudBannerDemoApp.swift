//
//  ICloudBannerDemoApp.swift
//  ICloudBannerDemo
//
//  Created by Mohammad Azam on 12/22/25.
//

import SwiftUI

@main
struct ICloudBannerDemoApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var iCloudStatusProvider = ICloudStatusProvider()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(iCloudStatusProvider)
                .onChange(of: scenePhase) {
                    if scenePhase == .active {
                        iCloudStatusProvider.refresh()
                    }
                }
        }
    }
}
