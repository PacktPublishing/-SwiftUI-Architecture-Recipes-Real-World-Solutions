//
//  ContentView.swift
//  Learn
//
//  Created by Mohammad Azam on 5/27/25.
//

import SwiftUI
import SwiftData

@Model
class Book {
    
    var title: String
    var author: String
    var isCompleted: Bool
    
    init(title: String, author: String, isCompleted: Bool = false) {
        self.title = title
        self.author = author
        self.isCompleted = isCompleted
    }
    
}

struct BookListView: View {
    
    @Query private var books: [Book] = []
    
    init(sortDirection: SortDirection) {
        
        //let sort = SortDescriptor(\Book.isCompleted, order: sortDirection == .ascending ? .forward: .reverse)
        //_books = Query(sort: [sort])
        
        
    }
    
    var body: some View {
        List(books) { book in
            Text(book.title)
        }
    }
}

enum SortDirection {
    case ascending
    case descending
}

struct ContentView: View {
    
    @State private var sortDirection: SortDirection = .ascending
    @State private var isCompleted: Bool = false
    
    var body: some View {
        VStack {
            Button("Sort Ascending") {
                sortDirection = .ascending
            }
            
            Button("Sort Descending") {
                sortDirection = .descending
            }
            
            BookListView(sortDirection: sortDirection)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
