import SwiftUI

struct SettingsScreen: View {
    @State private var isNotificationsOn = true
    @State private var isDarkModeOn = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("John Doe")
                                .font(.headline)
                            Text("john@example.com")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: $isNotificationsOn)
                    Toggle("Dark Mode", isOn: $isDarkModeOn)
                }
                
                Section {
                    Button(role: .destructive) {
                        // Sign-out action
                    } label: {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsScreen()
}
