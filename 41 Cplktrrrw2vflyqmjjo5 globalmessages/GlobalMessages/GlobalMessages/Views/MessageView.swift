//
//  MessageView.swift
//  GlobalMessages
//
//  Created by Mohammad Azam on 10/17/24.
//

import SwiftUI

struct MessageView: View {
    
    @Binding var messageWrapper: MessageWrapper?
    
    private var backgroundColor: Color {
        
        guard let messageType = messageWrapper?.messageType else {
            return .clear
        }
        
        switch messageType {
            case .error:
                return .red
            case .info:
                return .blue
            case .success:
                return .green
        }
    }
    
    var body: some View {
        Text(messageWrapper?.message ?? "")
            .frame(width: 300)
            .padding()
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
            .foregroundStyle(.white)
            .task(id: messageWrapper?.id) {
                try? await Task.sleep(for: .seconds(messageWrapper?.delay ?? 2.0))
                guard !Task.isCancelled else { return }
                withAnimation {
                    messageWrapper = nil 
                }
            }
    }
}

#Preview {
    MessageView(messageWrapper: .constant(MessageWrapper(message: "This is an error message.")))
}
