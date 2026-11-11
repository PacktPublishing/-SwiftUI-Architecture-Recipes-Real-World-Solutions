//
//  ContentView.swift
//  MyGreenPlace
//
//  Created by Mohammad Azam on 11/19/25.
//

import SwiftUI
import StoreKit

struct VegetableListScreen: View {
    
    @Environment(VeggieStore.self) private var veggieStore
    @Environment(\.reviewManager) private var reviewManager
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        List {
            ForEach(veggieStore.vegetables) { vegetable in
                
                NavigationLink {
                    VegetableDetailScreen(vegetable: vegetable)
                } label: {
                    VegetableRow(vegetable: vegetable)
                }
            }
        }
        .onAppear(perform: {
            reviewManager.requestReviewIfNeeded(criteria: .launch, requestReview: {
                requestReview() 
            })
        })
        
        .task {
            do {
                try veggieStore.loadVegetables()
            } catch {
                print(error.localizedDescription)
            }
        }.navigationTitle("Vegetables")
    }
}

#Preview {
    NavigationStack {
        VegetableListScreen()
    }
    .environment(VeggieStore())
}
