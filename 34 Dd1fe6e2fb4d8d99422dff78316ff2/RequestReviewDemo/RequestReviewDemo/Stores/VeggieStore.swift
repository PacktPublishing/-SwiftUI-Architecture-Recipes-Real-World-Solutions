//
//  VeggieStore.swift
//  MyGreenPlace
//
//  Created by Mohammad Azam on 11/20/25.
//

import Foundation
import Observation

@Observable
class VeggieStore {
    
    private(set) var vegetables: [Vegetable] = []
    
    func loadVegetables() throws {
        
        guard let url = Bundle.main.url(forResource: "vegetables", withExtension: "json") else {
            fatalError("Could not find vegetables.json in bundle")
        }
        
        let data = try Data(contentsOf: url)
        vegetables = try JSONDecoder().decode([Vegetable].self, from: data).sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
