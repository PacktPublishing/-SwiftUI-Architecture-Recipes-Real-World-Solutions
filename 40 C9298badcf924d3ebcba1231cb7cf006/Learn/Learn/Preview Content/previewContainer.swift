//
//  previewContainer.swift
//  Learn
//
//  Created by Mohammad Azam on 6/2/25.
//

import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    
    let books = [
        Book(title: "The Swift Journey", author: "Mohammad Azam", isCompleted: true),
        Book(title: "Mastering SwiftUI", author: "Mohammad Azam", isCompleted: false),
        Book(title: "Building Apps with SwiftData", author: "Mohammad Azam", isCompleted: true),
        Book(title: "iOS Architecture Patterns", author: "Jane Doe", isCompleted: false),
        Book(title: "Async Await in Practice", author: "John Smith", isCompleted: true)
    ]

    let container = try! ModelContainer(for: Book.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    // insert few books
    for book in books {
        container.mainContext.insert(book)
    }
    
    return container
    
}()
