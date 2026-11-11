//
//  VeggieGardenStoreData.swift
//  MyGreenPlace
//
//  Created by Mohammad Azam on 11/20/25.
//

import Foundation
import SwiftUI

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor
    static var veggieGardenSampleData: Self {
        .modifier(VeggieGardenStoreData())
    }
}

struct VeggieGardenStoreData: PreviewModifier {
    
    static func makeSharedContext() async throws -> VeggieStore {
        let veggieStore = VeggieStore()
        try veggieStore.loadVegetables()
        return veggieStore
    }
    
    func body(content: Content, context: VeggieStore) -> some View {
        content
            .environment(context)
    }
}
