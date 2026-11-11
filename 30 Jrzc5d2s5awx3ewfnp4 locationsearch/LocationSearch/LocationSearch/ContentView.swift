//
//  ContentView.swift
//  LocationSearch
//
//  Created by Mohammad Azam on 4/14/25.
//

import SwiftUI
import MapKit
import Observation

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let subTitle: String
    
    var address: String {
        "\(name) \(subTitle)"
    }
}

@Observable
class LocationSearchService: NSObject, MKLocalSearchCompleterDelegate {
    
    var places: [Place] = []
    var message: String = ""
    private var localSearchCompleter: MKLocalSearchCompleter
    
    override init() {
        localSearchCompleter = MKLocalSearchCompleter()
        super.init()
        localSearchCompleter.delegate = self
    }
    
    func searchLocation(search: String) {
        guard !search.isEmpty else { return }
        localSearchCompleter.queryFragment = search
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        places = completer.results.map {
            Place(name: $0.title, subTitle: $0.subtitle)
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        message = error.localizedDescription
    }
}

struct ContentView: View {
    
    @Environment(LocationSearchService.self) private var locationService
    @State private var search: String = ""
    @State private var selectedPlace: Place?
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Search Address")
                    .font(.headline)
                
                TextField("Enter address", text: $search)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .onChange(of: search) {
                        if search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            locationService.places = [] // Clear results
                        } else {
                            locationService.searchLocation(search: search)
                        }
                    }
            }
            
            GroupBox {
                if let selectedPlace {
                    Text(selectedPlace.address)
                }
            }.opacity(selectedPlace == nil ? 0: 1)
            
            if locationService.places.isEmpty {
                Spacer()
                VStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("No results yet")
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                Spacer()
            } else {
                List(locationService.places) { place in
                    VStack(alignment: .leading) {
                        Text(place.address)
                            .font(.body)
                            .foregroundColor(.primary)
                            .onTapGesture {
                                selectedPlace = place
                            }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.insetGrouped)
            }
        }
        .padding()
        .navigationTitle("Location Finder")
    }
}

#Preview {
    ContentView()
        .environment(LocationSearchService())
}
