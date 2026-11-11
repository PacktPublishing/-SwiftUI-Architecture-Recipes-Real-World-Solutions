//
//  ContentView.swift
//  CleanSwiftUIDataLoading
//
//  Created by Mohammad Azam on 1/17/26.
//

import SwiftUI
import Observation

enum SampleError: Error {
    case operationFailed
}

struct Budget: Identifiable, Codable {
    let id: UUID
    let name: String
    let limit: Double
}

struct HTTPClient {
    
    func fetchBudgets() async throws -> [Budget] {
        try? await Task.sleep(for: .seconds(2.0))
        return [Budget(id: UUID(), name: "Groceries", limit: 500), Budget(id: UUID(), name: "Vacation", limit: 1000)]
    }
    
}

@Observable
class BudgetStore {
    
    private(set) var budgets: [Budget] = []
    // use a protocol if mocking
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadBudgets() async throws {
        budgets = try await httpClient.fetchBudgets()
    }
    
    func saveBudget(_ budget: Budget) {
        self.budgets.append(budget)
    }
    
}

struct BudgetListView: View {
    
    let budgets: [Budget]
    
    var body: some View {
        List(budgets) { budget in
            Text(budget.name)
        }
    }
}

struct AddBudgetScreen: View {
    
    @Environment(BudgetStore.self) private var budgetStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button("Save") {
            let budget = Budget(id: UUID(), name: "Car Rental", limit: 450)
            budgetStore.saveBudget(budget)
            dismiss()
        }
    }
}

struct ContentView: View {
    
    @Environment(BudgetStore.self) private var budgetStore
    @State private var loadingStatus: LoadingStatus = .loading
    @State private var presentAddBudget: Bool = false
    
    enum LoadingStatus {
        case loading
        case success
        case failure
    }
    
    private func loadBudgets() async {
        do {
            try await budgetStore.loadBudgets()
            loadingStatus = .success
        } catch {
            loadingStatus = .failure
        }
    }
    
    var body: some View {
        switch loadingStatus {
            case .loading:
                ProgressView("Loading...")
                .task {
                    await loadBudgets()
                }
            case .success:
                if budgetStore.budgets.isEmpty {
                    ContentUnavailableView("There are no budgets.", systemImage: "heart")
                } else {
                    BudgetListView(budgets: budgetStore.budgets)
                        .refreshable {
                            await loadBudgets()
                        }.navigationTitle("Budgets")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Add Budget") {
                                    presentAddBudget = true
                                }
                            }
                        }.sheet(isPresented: $presentAddBudget) {
                            AddBudgetScreen()
                        }
                }
            case .failure:
                ContentUnavailableView(
                 "Something went wrong",
                 systemImage: "exclamationmark.triangle",
                 description: Text("Please try again.")
            )
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
    .environment(BudgetStore(httpClient: HTTPClient()))
}
