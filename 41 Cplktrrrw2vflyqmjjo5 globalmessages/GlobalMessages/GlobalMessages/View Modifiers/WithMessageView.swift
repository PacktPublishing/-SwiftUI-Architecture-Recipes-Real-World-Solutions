//
//  WithMessageView.swift
//  GlobalMessages
//
//  Created by Mohammad Azam on 10/17/24.
//

import Foundation
import SwiftUI

struct MessageWrapper: Identifiable {
    let id = UUID()
    var message: String
    var delay: Double = 2.0
    var messageType: MessageType = .error
}

struct WithMessageView: ViewModifier {
    
    @State private var messageWrapper: MessageWrapper?
    
    func body(content: Content) -> some View {
        content
            .environment(\.showMessage, ShowMessageAction(action: { message, messageType, delay in
                self.messageWrapper = MessageWrapper(message: message, delay: delay, messageType: messageType)
            }))
            .overlay(alignment: .bottom) {
                messageWrapper != nil ? MessageView(messageWrapper: $messageWrapper): nil
            }
    }
    
}

extension View {
    
    func withMessageView() -> some View {
        modifier(WithMessageView())
    }
    
}
