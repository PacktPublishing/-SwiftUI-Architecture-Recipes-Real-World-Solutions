//
//  ContentView.swift
//  AbstractingSwiftData
//
//  Created by Mohammad Azam on 4/8/26.
//

import SwiftUI
import SwiftData
import SQLiteData
 
struct Budget: Identifiable {
    let id: UUID
    let name: String
    let limit: Double
}

@Model
class BudgetModel {
    var id: UUID
    var name: String
    var limit: Double
    
    init(id: UUID = UUID(), name: String, limit: Double) {
        self.id = id
        self.name = name
        self.limit = limit
    }
}

@Table
struct BudgetItem: Identifiable {
    let id: UUID
    var name: String
    var limit: Double
}

protocol DataAccess {
    func saveBudget(name: String, limit: Double) throws
    func fetchBudgets() throws -> [Budget]
}

struct SQLiteDataAccess: DataAccess {
    
    let db: DatabaseWriter
    
    func saveBudget(name: String, limit: Double) throws {
        let budgetItem = BudgetItem(id: UUID(), name: name, limit: limit)
        try db.write { db in
            try BudgetItem.insert { budgetItem }
                .execute(db)
        }
    }
    
    func fetchBudgets() throws -> [Budget] {
        return try db.read { db in
            // fetch from database
            return try BudgetItem.fetchAll(db).map {
                Budget(id: $0.id, name: $0.name, limit: $0.limit)
            }
        }
    }
}

struct SwiftDataAccess: DataAccess {
    
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveBudget(name: String, limit: Double) throws {
        let budgetModel = BudgetModel(name: name, limit: limit)
        modelContext.insert(budgetModel)
        try modelContext.save()
    }
    
    func fetchBudgets() throws -> [Budget] {
        
        let descriptor = FetchDescriptor<BudgetModel>()
        
        let budgetModels = try modelContext.fetch(descriptor)
        return budgetModels.map {
            Budget(id: $0.id, name: $0.name, limit: $0.limit)
        }
    }
}

struct ContentView: View {
    
    @Environment(\.dataAccess) private var dataAccess
    @State private var name: String = ""
    @State private var budgets: [Budget] = []
    
    private func loadBudgets() {
        do {
            budgets = try dataAccess.fetchBudgets()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            TextField("Enter name", text: $name)
                .textFieldStyle(.roundedBorder)
            
            Button("Save") {
                
                do {
                    try dataAccess.saveBudget(name: name, limit: Double.random(in: 100...500))
                    loadBudgets()
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            List(budgets) { budget in
                Text(budget.name)
            }
            
        }.onAppear(perform: loadBudgets)
        .padding()
    }
}

#Preview {
    ContentView()
}
