//
//  ViewController.swift
//  Learn
//
//  Created by Mohammad Azam on 7/1/25.
//

import Foundation
import UIKit
import Observation

@Observable
class AuthStatus {
    var isLoggedIn: Bool = false
}

class ViewController: UIViewController {
    
    private let authStatus = AuthStatus()
    
    private lazy var authStatusToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = false
        toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
        return toggle
    }()
    
    lazy var loginStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Not logged in."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc private func toggleChanged(_ sender: UISwitch) {
        authStatus.isLoggedIn = sender.isOn
    }
    
    override func updateProperties() {
        super.updateProperties()
        print("updateProperties")
        
        loginStatusLabel.text = authStatus.isLoggedIn ? "Logged In": "Not Logged In."
    }
    
    override func viewWillLayoutSubviews() {  
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubviews")
          
        //loginStatusLabel.text = authStatus.isLoggedIn ? "Logged In": "Not Logged In"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(authStatusToggle)
        view.addSubview(loginStatusLabel)
        
        NSLayoutConstraint.activate([
            authStatusToggle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authStatusToggle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginStatusLabel.topAnchor.constraint(equalTo: authStatusToggle.bottomAnchor, constant: 20)
        ])
    }
    
}

#Preview {
    ViewController()
}
