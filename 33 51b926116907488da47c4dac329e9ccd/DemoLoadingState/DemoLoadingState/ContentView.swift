//
//  ContentView.swift
//  DemoLoadingState
//
//  Created by Mohammad Azam on 6/29/25.
//

import SwiftUI

struct Product: Decodable, Identifiable {
    let id = UUID()
    let name: String
    
    private enum CodingKeys: CodingKey {
        case name
    }
}

enum SampleError: Error, LocalizedError {
    case operationFailed

    var errorDescription: String? {
        switch self {
        case .operationFailed:
            return NSLocalizedString("The operation failed. Please try again later.", comment: "Operation Failed Error")
        }
    }
}

enum LoadingState<T> {
    case loading
    case success(T)
    case failure(Error)
}

struct LoadingStateView<Content, T>: View where Content: View {
    let state: LoadingState<T>
    let content: (T) -> Content
    
    var body: some View {
        switch state {
            case .loading:
                ProgressView("Loading...")
            case .success(let data):
                content(data)
            case .failure(let error):
                Text(error.localizedDescription)
                    .foregroundColor(.red)
        }
    }
}

struct ContentView: View {
    
    @State private var loadingState: LoadingState<[Product]> = .loading
    
    private func loadProducts() async {
        do {
            try await Task.sleep(for: .seconds(2.0))
            loadingState = .success([Product(name: "Shirts"), Product(name: "iPhone")])
        } catch {
            loadingState = .failure(error)
        }
    }
    
    var body: some View {
        
        LoadingStateView(state: loadingState) { products in
            List(products) { product in
                Text(product.name)
            } 
        }.task {
            await loadProducts()
        }
        
    }
}

#Preview {
    ContentView()
}
