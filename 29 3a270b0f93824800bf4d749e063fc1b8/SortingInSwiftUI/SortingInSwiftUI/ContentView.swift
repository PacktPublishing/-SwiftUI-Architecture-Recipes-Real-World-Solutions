//
//  ContentView.swift
//  SortingInSwiftUI
//
//  Created by Mohammad Azam on 9/8/25.
//

import SwiftUI

struct Hotel: Identifiable {
    let id = UUID()
    let name: String
    let distanceToDowntown: Measurement<UnitLength>
    let price: Double
    let guestRating: Double
}

enum SortOptions: Identifiable, CaseIterable {
    case priceLowToHigh
    case priceHighToLow
    case distanceToDowntown
    case guestRating
    
    var id: Self { self }   // each case is unique
    
    var title: String {
        switch self {
            case .priceLowToHigh:
                return "Price: low to high"
            case .priceHighToLow:
                return "Price: high to low"
            case .distanceToDowntown:
                return "Distance to downtown"
            case .guestRating:
                return "Guest rating"
        }
    }
}

struct ContentView: View {
    
    @State private var selectedSortOption: SortOptions = .priceLowToHigh
    
    @State private var hotels = [
        Hotel(name: "Grand Central Hotel", distanceToDowntown: Measurement(value: 1.2, unit: .miles), price: 180, guestRating: 4.5),
        Hotel(name: "Riverside Inn", distanceToDowntown: Measurement(value: 3.8, unit: .miles), price: 65, guestRating: 4.0),
        Hotel(name: "Luxury Palace", distanceToDowntown: Measurement(value: 0.5, unit: .miles), price: 320, guestRating: 4.8),
        Hotel(name: "Downtown Suites", distanceToDowntown: Measurement(value: 0.8, unit: .miles), price: 150, guestRating: 4.3),
        Hotel(name: "Cityview Lodge", distanceToDowntown: Measurement(value: 2.5, unit: .miles), price: 120, guestRating: 3.9),
        Hotel(name: "Economy Stay", distanceToDowntown: Measurement(value: 4.0, unit: .miles), price: 80, guestRating: 3.7),
        Hotel(name: "Skyline Hotel", distanceToDowntown: Measurement(value: 1.0, unit: .miles), price: 200, guestRating: 4.6),
        Hotel(name: "Comfort Inn", distanceToDowntown: Measurement(value: 2.0, unit: .miles), price: 110, guestRating: 4.1),
        Hotel(name: "Urban Retreat", distanceToDowntown: Measurement(value: 0.7, unit: .miles), price: 250, guestRating: 4.7),
        Hotel(name: "Traveler’s Haven", distanceToDowntown: Measurement(value: 5.2, unit: .miles), price: 70, guestRating: 3.5)
    ]
    
    private func applySort() {
        
        switch selectedSortOption {
        case .priceLowToHigh:
            hotels.sort { $0.price < $1.price }
        case .priceHighToLow:
            hotels.sort { $0.price > $1.price }
        case .distanceToDowntown:
            hotels.sort { $0.distanceToDowntown < $1.distanceToDowntown }
        case .guestRating:
            hotels.sort { $0.guestRating > $1.guestRating }
        }

    }
    
    var body: some View {
        VStack {
            
            Picker("Select sort option", selection: $selectedSortOption) {
                ForEach(SortOptions.allCases) { option in
                    Text(option.title)
                        .tag(option)
                }
            }
            
            List(hotels) { hotel in
                HotelCellView(hotel: hotel)
            }
        }
        .onChange(of: selectedSortOption, initial: true, {
            applySort()
        })
        .padding()
    }
}

struct HotelCellView: View {
    let hotel: Hotel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(hotel.name)
                .font(.headline)
            
            HStack {
                Text(hotel.distanceToDowntown, format: .measurement(width: .abbreviated, usage: .road))
                Spacer()
                Label("$\(hotel.price, specifier: "%.0f") / night",
                      systemImage: "dollarsign.circle")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            HStack(spacing: 2) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(hotel.guestRating.rounded())
                          ? "star.fill" : "star")
                        .foregroundColor(index < Int(hotel.guestRating.rounded()) ? .yellow : .gray)
                }
                Text("(\(hotel.guestRating, specifier: "%.1f"))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ContentView()
}
