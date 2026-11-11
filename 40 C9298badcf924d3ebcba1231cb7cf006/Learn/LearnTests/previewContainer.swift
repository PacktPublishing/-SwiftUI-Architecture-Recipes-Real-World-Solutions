//
//  previewContainer.swift
//  Learn
//
//  Created by Mohammad Azam on 6/2/25.
//

import Foundation
import SwiftData
@testable import Learn 

@MainActor
let previewContainer: ModelContainer = {
    
    let books = [
        Book(title: "The Swift Journey", author: "Mohammad Azam"),
        Book(title: "Mastering SwiftUI", author: "Mohammad Azam"),
        Book(title: "Building Apps with SwiftData", author: "Mohammad Azam"),
        Book(title: "iOS Architecture Patterns", author: "Jane Doe"),
        Book(title: "Async Await in Practice", author: "John Smith")
    ]
    
    let container = try! ModelContainer(for: Book.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    // insert few books
    for book in books {
        container.mainContext.insert(book)
    }
    
    return container
    
}()
