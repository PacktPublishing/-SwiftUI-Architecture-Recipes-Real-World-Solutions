//
//  ContentView.swift
//  ShowSheetsDemo
//
//  Created by Mohammad Azam on 4/23/25.
//

import SwiftUI

enum Sheet: Identifiable, Hashable {
    case settings
    case contact(String)
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .settings:
                SettingsScreen()
            case .contact(let name):
                ContactScreen(fullName: name)
        }
    }
    
    var id: Self { self }
}

struct SheetAction {
    typealias Action = (Sheet) -> Void
    let action: Action
    
    func callAsFunction(_ sheet: Sheet) {
        action(sheet)
    }
}

extension EnvironmentValues {
    @Entry var showSheet = SheetAction { _ in }
}

struct ContentView: View {
    
    @Environment(\.showSheet) private var showSheet
    
    var body: some View {
        VStack {
            Button("Show Settings") {
                showSheet(.settings)
            }
            
            Button("Contact") {
                showSheet(.contact("John Doe"))
            }
        }
        .padding()
    }
}

#Preview {
    
    @Previewable @State var selectedSheet: Sheet?
    
    ContentView()
        .environment(\.showSheet, SheetAction(action: { sheet in
            selectedSheet = sheet
        }))
        .sheet(item: $selectedSheet) { sheet in
            sheet.destination
        }
}
