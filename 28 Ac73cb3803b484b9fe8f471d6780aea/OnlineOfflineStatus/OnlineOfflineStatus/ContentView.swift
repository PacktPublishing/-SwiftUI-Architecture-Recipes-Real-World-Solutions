//
//  ContentView.swift
//  OnlineOfflineStatus
//
//  Created by Mohammad Azam on 7/6/26.
//

import SwiftUI
import Observation
import Network

enum NetworkStatus {
    case online
    case offline
}

@Observable
class NetworkStatusManager {
    
    var status: NetworkStatus = .offline
    let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.status = path.status == .satisfied ? .online : .offline
            }
        }
        
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}

struct NetworkStatusView: View {
    
    let networkStatusManager: NetworkStatusManager
    
    var body: some View {
        Text(networkStatusManager.status == .online ? "Online" : "Offline")
            .padding(6)
            .foregroundStyle(.white)
            .background(networkStatusManager.status == .online ? .green : .red)
            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}


