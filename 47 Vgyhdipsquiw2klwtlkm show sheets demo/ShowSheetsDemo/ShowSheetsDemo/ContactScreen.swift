import SwiftUI

struct ContactScreen: View {
    
    let fullName: String
    
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact Information")) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("+1 (555) 123-4567")
                    }
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("support@example.com")
                    }
                }
                
                Section(header: Text("Send us a message")) {
                    TextField("Your Name", text: $name)
                    TextField("Your Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextEditor(text: $message)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4))
                        )
                }
                
                Section {
                    Button(action: {
                        // Send message action
                    }) {
                        Text("Submit")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Contact Us")
        }
    }
}

#Preview {
    ContactScreen(fullName: "John Doe")
}
