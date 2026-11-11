//
//  RequestReviewDemoApp.swift
//  RequestReviewDemo
//
//  Created by Mohammad Azam on 12/2/25.
//

import SwiftUI

@main
struct RequestReviewDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                VegetableListScreen()
            }.environment(VeggieStore())
        }
    }
}
