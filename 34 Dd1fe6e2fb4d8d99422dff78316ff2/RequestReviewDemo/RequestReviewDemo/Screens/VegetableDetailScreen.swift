//
//  VegetableDetailScreen.swift
//  GreenThumb
//
//  Created by Mohammad Azam on 10/3/25.
//

import SwiftUI
import StoreKit

struct VegetableDetailScreen: View {
    
    let vegetable: Vegetable
    
    @Environment(\.reviewManager) private var reviewManager
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
                        
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(vegetable.body)
                    
                    Text("Quick Facts")
                        .padding(.top, 10)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    DetailRow(icon: "leaf", title: "Seed Depth", value: vegetable.seedDepth)
                    DetailRow(icon: "thermometer", title: "Germination Temp", value: vegetable.germinationSoilTemp)
                    DetailRow(icon: "calendar", title: "Days to Germination", value: "\(vegetable.daysToGermination) days")
                    DetailRow(icon: "allergens", title: "Days to Harvest (Seeds)", value: "\(vegetable.daysToHarvestSeeds) days")
                    DetailRow(icon: "apple.meditate", title: "Days to Harvest (Seedlings)", value: "\(vegetable.daysToHarvestSeedlings) days")
                    
                    DetailRow(icon: "sun.max", title: "Light Requirement", value: vegetable.light)
                    DetailRow(icon: "drop", title: "Watering", value: vegetable.watering)
                    DetailRow(icon: "leaf.arrow.triangle.circlepath", title: "Companions", value: vegetable.goodCompanions)
                    DetailRow(icon: "exclamationmark.triangle", title: "Bad Companions", value: vegetable.badCompanions)
                    DetailRow(icon: "heart.fill", title: "Health Benefits", value: vegetable.healthBenefits.isEmpty ? "N/A" : vegetable.healthBenefits)
                  
                    
                    SectionHeader(title: "Sowing Tips")
                    Text(vegetable.sowingDescription ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    SectionHeader(title: "Growing Tips")
                    Text(vegetable.growingDescription)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    SectionHeader(title: "Harvest Tips")
                    Text(vegetable.harvestDescription)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding() // padding only inside scroll view
            }
            
             
           
        }.toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Harvest") {
                    // perform the harvest
                    
                    // do some animation/celebration
                    
                    // ask for review
                    
                    reviewManager.requestReviewIfNeeded(criteria: .delay(seconds: 5)) {
                        requestReview()
                    }
                }
            }
        })
      
        .navigationTitle(vegetable.name)
        .toolbarBackground(.hidden, for: .navigationBar) // ✅ Transparent nav bar
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.top)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DetailRow: View {
    
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 24, height: 24)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview(traits: .veggieGardenSampleData) {
    
    @Previewable @Environment(VeggieStore.self) var veggieStore
    NavigationStack {
        VegetableDetailScreen(vegetable: veggieStore.vegetables[0])
    }
}


