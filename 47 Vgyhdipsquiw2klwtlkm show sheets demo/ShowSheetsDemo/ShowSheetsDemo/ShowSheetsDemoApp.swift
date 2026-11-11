//
//  ShowSheetsDemoApp.swift
//  ShowSheetsDemo
//
//  Created by Mohammad Azam on 4/23/25.
//

import SwiftUI

@main
struct ShowSheetsDemoApp: App {
    
    @State var selectedSheet: Sheet?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.showSheet, SheetAction(action: { sheet in
                    selectedSheet = sheet
                }))
                .sheet(item: $selectedSheet) { sheet in
                    sheet.destination
                }
        }
    }
}
