//
//  ContentView.swift
//  ContainerPresenterDemo
//
//  Created by Mohammad Azam on 9/6/25.
//

import SwiftUI

struct User: Decodable, Identifiable {
    let id: Int
    let name: String
}

struct HTTPClient {
    
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([User].self, from: data)
    }
}

extension EnvironmentValues {
    @Entry var httpClient = HTTPClient()
}

struct UserListView: View {
    
    let users: [User]
    
    var body: some View {
        List(users) { user in
           UserCellView(user: user)
        }
    }
}

struct UserCellView: View {
    
    let user: User
    
    var body: some View {
        Text(user.name)
    }
}

struct UserListScreen: View {
    
    @Environment(\.httpClient) private var httpClient
    @State private var users: [User] = []
    
    var body: some View {
        UserListView(users: users)
            .task {
            do {
                users = try await httpClient.fetchUsers()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    UserListScreen()
}
