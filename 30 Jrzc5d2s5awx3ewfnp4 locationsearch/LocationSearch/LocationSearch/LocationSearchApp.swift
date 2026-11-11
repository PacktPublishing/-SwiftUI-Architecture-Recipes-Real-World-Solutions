//
//  LocationSearchApp.swift
//  LocationSearch
//
//  Created by Mohammad Azam on 4/14/25.
//

import SwiftUI

@main
struct LocationSearchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(LocationSearchService())
        }
    }
}
