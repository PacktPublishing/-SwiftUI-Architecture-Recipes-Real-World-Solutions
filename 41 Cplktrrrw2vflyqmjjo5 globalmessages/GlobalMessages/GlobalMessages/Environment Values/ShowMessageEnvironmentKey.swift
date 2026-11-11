//
//  ShowMessageEnvironmentKey.swift
//  GlobalMessages
//
//  Created by Mohammad Azam on 10/17/24.
//

import Foundation
import SwiftUI

enum MessageType {
    case error
    case info
    case success
}

struct ShowMessageAction {
    typealias Action = (String, MessageType, Double) -> ()
    let action: Action
    
    func callAsFunction(_ message: String, _ messageType: MessageType = .error, _ delay: Double = 2.0) {
        action(message, messageType, delay)
    }
}

struct ShowMessageEnvironmentKey: EnvironmentKey {
    static var defaultValue: ShowMessageAction = ShowMessageAction { _, _, _ in }
}

extension EnvironmentValues {
    var showMessage: (ShowMessageAction) {
        get { self[ShowMessageEnvironmentKey.self] }
        set { self[ShowMessageEnvironmentKey.self] = newValue }
    }
}
