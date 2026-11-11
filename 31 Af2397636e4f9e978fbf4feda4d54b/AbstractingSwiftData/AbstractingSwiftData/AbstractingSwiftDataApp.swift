//
//  AbstractingSwiftDataApp.swift
//  AbstractingSwiftData
//
//  Created by Mohammad Azam on 4/8/26.
//

import SwiftUI
import SwiftData
import SQLiteData

extension EnvironmentValues {
    @Entry var dataAccess: DataAccess = DefaultDataAccess()
}

struct DefaultDataAccess: DataAccess {
    
    func saveBudget(name: String, limit: Double) throws {
        fatalError("DataAccess has not been injected into the environment.")
    }
    
    func fetchBudgets() throws -> [Budget] {
        fatalError("DataAccess has not been injected into the environment.")
    }
}

@main
struct AbstractingSwiftDataApp: App {
    
    let dataAccess: DataAccess
    //let container: ModelContainer
    
    init() {
        /*
        container = try! ModelContainer(
            for: BudgetModel.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
        
        self.dataAccess = SwiftDataAccess(modelContext: container.mainContext)
         */
        
        let db = Self.makeSQLiteDatabase()
        self.dataAccess = SQLiteDataAccess(db: db)
    }
    
    private static func makeSQLiteDatabase() -> DatabaseWriter {
        let url = URL.documentsDirectory.appending(path: "budgets.sqlite")
        let database = try! DatabaseQueue(path: url.path)
        
        prepareDependencies {
            $0.defaultDatabase = database
            
            try! database.write { db in
                try! db.create(table: "budgetItems", ifNotExists: true) { t in
                    t.primaryKey("id", .text)
                    t.column("name", .text)
                    t.column("limit", .double)
                }
            }
        }
        
        return database
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.dataAccess, dataAccess)
        }
    }
}
