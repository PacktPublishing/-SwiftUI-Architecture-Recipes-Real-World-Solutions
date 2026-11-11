//
//  Vegetable.swift
//  GreenThumb
//
//  Created by Mohammad Azam on 2/6/25.
//

import Foundation

struct Vegetable: Decodable, Identifiable {
    let id = UUID()
    var vegetableId: Int = -1
    var vegetableCode: String = ""
    var name: String = ""
    var body: String = ""
    var thumbnailImage: URL?
    var seedDepth: String = ""
    var germinationSoilTemp: String = ""
    var daysToGermination: Int = -1
    var sowIndoors: String = ""
    var sowOutdoors: String = ""
    var phRange: String = ""
    var growingSoilTemp: String = ""
    var spacingBeds: String = ""
    var watering: String = ""
    var light: String = ""
    var goodCompanions: String = ""
    var badCompanions: String = ""
    var sowingDescription: String?
    var growingDescription: String = ""
    var harvestDescription: String = ""
    var active: Bool?
    var season: String = ""
    var daysToHarvestSeeds: Int = -1
    var daysToHarvestSeedlings: Int = -1
    var healthBenefits: String = ""

    
    enum CodingKeys: String, CodingKey {
        case vegetableId = "VegetableId"
        case vegetableCode = "VegetableCode"
        case name = "Name"
        case body = "Description"
        case thumbnailImage = "ThumbnailImage"
        case seedDepth = "SeedDepth"
        case germinationSoilTemp = "GerminationSoilTemp"
        case daysToGermination = "DaysToGermination"
        case sowIndoors = "SowIndoors"
        case sowOutdoors = "SowOutdoors"
        case phRange = "PhRange"
        case growingSoilTemp = "GrowingSoilTemp"
        case spacingBeds = "SpacingBeds"
        case watering = "Watering"
        case light = "Light"
        case goodCompanions = "GoodCompanions"
        case badCompanions = "BadCompanions"
        case sowingDescription = "SowingDescription"
        case growingDescription = "GrowingDescription"
        case harvestDescription = "HarvestDescription"
        case active = "Active"
        case season = "Season"
        case daysToHarvestSeeds = "DaysToHarvestSeeds"
        case daysToHarvestSeedlings = "DaysToHarvestSeedlings"
        case healthBenefits = "HealthBenefits"
    }
  
}
