//
//  LearnTests.swift
//  LearnTests
//
//  Created by Mohammad Azam on 6/2/25.
//

import Testing
import SwiftData
@testable import Learn

struct LearnTests {

    private var container: ModelContainer
    
    init() {
        container = try! ModelContainer(for: Book.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }
    
    @MainActor
    @Test func fetch_books_by_author() async throws {
            
        // add few books
        let books = [
            Book(title: "The Swift Journey", author: "Mohammad Azam"),
            Book(title: "Mastering SwiftUI", author: "Mohammad Azam"),
            Book(title: "Building Apps with SwiftData", author: "Mohammad Azam"),
            Book(title: "iOS Architecture Patterns", author: "Jane Doe"),
            Book(title: "Async Await in Practice", author: "John Smith")
        ]
        
        for book in books {
            container.mainContext.insert(book)
        }
        
        // now try to fetch it
        let fetchDescriptor = Book.by(author: "Mohammad Azam")
        
        let booksByAuthor: [Book] = try container.mainContext.fetch(fetchDescriptor)
        #expect(booksByAuthor.count == 3)
        
    }

}
