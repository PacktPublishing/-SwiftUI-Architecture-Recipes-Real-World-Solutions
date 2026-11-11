//
//  ContentView.swift
//  AsyncButtonDemo
//
//  Created by Mohammad Azam on 4/17/25.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    
    let action: () async -> Void
    let label: () -> Label
    
    @State private var task: Task<Void, Never>?
    @State private var isRunning = false
    
    var body: some View {
        HStack {
            Button {
                isRunning = true
                task = Task {
                    await action()
                    isRunning = false
                }
            } label: {
                label()
                    .opacity(isRunning ? 0.4: 1)
            }.disabled(isRunning)
            
            if isRunning {
                Button("Cancel") {
                    task?.cancel()
                    isRunning = false
                }.foregroundStyle(.red)
            }
        }.animation(.default, value: isRunning)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            AsyncButton {
                try? await Task.sleep(for: .seconds(2.0))
            } label: {
                Text("Upload")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
