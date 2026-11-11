//
//  ContentView.swift
//  GlobalMessages
//
//  Created by Mohammad Azam on 10/17/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.showMessage) private var showMessage
    
    var body: some View {
        VStack {
            Button("Add Customer") {
                showMessage("Success", .success)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ContentView()
        .withMessageView()
}
