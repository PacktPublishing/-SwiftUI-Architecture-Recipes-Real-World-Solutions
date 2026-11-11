//
//  ContentView.swift
//  ICloudBannerDemo
//
//  Created by Mohammad Azam on 12/22/25.
//

import SwiftUI
import Observation
import CloudKit

struct ICloudStatusView: View {
    
    @Environment(ICloudStatusProvider.self) private var iCloudProvider: ICloudStatusProvider
    
    var body: some View {
        Group {
            if let accountStatus = iCloudProvider.accountStatus {
                switch accountStatus {
                case .couldNotDetermine:
                    InfoView(
                        title: "Checking iCloud Status",
                        message: "We’re trying to determine your iCloud availability.",
                        systemImage: "icloud",
                        color: .gray
                    )
                case .available:
                    InfoView(
                        title: "iCloud is On",
                        message: "Your data will sync and back up automatically across devices.",
                        systemImage: "icloud.fill",
                        color: .green
                    )
                case .restricted:
                    InfoView(
                        title: "iCloud Restricted",
                        message: "iCloud access is restricted on this device. This may be due to parental controls or device policies.",
                        systemImage: "lock.fill",
                        color: .red
                    )
                case .noAccount:
                    InfoView(
                        title: "iCloud is Off",
                        message: "Data is stored only on this device. Sign in to iCloud to enable backup and sync.",
                        systemImage: "icloud.slash",
                        color: .orange
                    )
                case .temporarilyUnavailable:
                    InfoView(
                        title: "iCloud Temporarily Unavailable",
                        message: "iCloud is currently unavailable. Please try again later.",
                        systemImage: "clock.fill",
                        color: .yellow
                    )
                    
                @unknown default:
                    InfoView(
                        title: "iCloud Status Unknown",
                        message: "This device returned an iCloud status we don’t recognize yet. Please try again later.",
                        systemImage: "questionmark.circle",
                        color: .gray
                    )
                }
                
            }
            
        }
    }
}


struct InfoView: View {
    let title: String
    let message: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 36))
                .foregroundStyle(color)
            
            Text(title)
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

@Observable
class ICloudStatusProvider {
    
    private(set) var accountStatus: CKAccountStatus?
    
    func refresh() {
        Task {
            do {
                accountStatus = try await CKContainer.default().accountStatus()
            } catch {
                accountStatus = .couldNotDetermine
            }
        }
    }
    
}

struct ContentView: View {
    var body: some View {
        ICloudStatusView()
    }
}

#Preview {
    ContentView()
        .environment(ICloudStatusProvider())
}
