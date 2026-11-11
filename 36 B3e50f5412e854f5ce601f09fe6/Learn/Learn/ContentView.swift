//
//  ContentView.swift
//  Learn
//
//  Created by Mohammad Azam on 7/14/25.
//

import SwiftUI

struct NavigateAction {
    typealias Action = (Route) -> Void
    let action: Action
    
    func callAsFunction(_ route: Route) {
        action(route)
    }
}

extension EnvironmentValues {
    @Entry var navigate = NavigateAction(action: { _ in })
}


enum AppTab: Hashable {
    case patients
    case doctors
}

enum Route: Hashable {
    case patients(PatientRoutes)
    case doctors(DoctorRoutes)
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .patients(let patientRoutes):
                patientRoutes.destination
            case .doctors(let doctorRoutes):
                doctorRoutes.destination
        }
    }
}

enum PatientRoutes: Hashable {
    case list
    case detail(Int)
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .list:
                Text("Patient List")
                // PatientListScreen
            case .detail(let id):
                Text("Patient Detail Screen \(id)")
                // PatientDetailScreen
        }
    }
}

enum DoctorRoutes: Hashable {
    case list
    case detail(Int)
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .list:
                Text("Doctors List Screen")
            case .detail(let id):
                Text("Doctor Detail Screen \(id)")
        }
    }
}

struct PatientScreen: View {
    
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        Button("Go to Patient List Screen") {
            navigate(.patients(.list))
        }
    }
}

struct DoctorScreen: View {
    
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack {
            
            Button("Go to Doctor Detail Screen") {
                navigate(.doctors(.detail(2)))
            }
            
            Button("Show Patient List Screen") {
                navigate(.patients(.list))
            }
        }.navigationTitle("Doctor Screen")
    }
}

struct ContentView: View {
    
    @State private var selectedTab: AppTab = .patients
    @State private var routes: [AppTab: NavigationPath] = [: ]
    
    private func binding(for tab: AppTab) -> Binding<NavigationPath> {
        Binding(
            get: { routes[tab, default: NavigationPath()] },
            set: { routes[tab] = $0 }
        )
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Tab("Patients", systemImage: "heart", value: AppTab.patients) {
                NavigationStack(path: binding(for: .patients)) {
                    PatientScreen()
                        .navigationDestination(for: Route.self) { route in
                            route.destination
                        }
                }
            }
            
            Tab("Doctors", systemImage: "cross", value: AppTab.doctors) {
                NavigationStack(path: binding(for: .doctors)) {
                    DoctorScreen()
                        .navigationDestination(for: Route.self) { route in
                            route.destination
                        }
                }
            }
        }.environment(\.navigate, NavigateAction(action: { route in
            
            var navigationPath = routes[selectedTab, default: NavigationPath()]
            navigationPath.append(route)
            routes[selectedTab] = navigationPath
            
        }))
    }
}

#Preview {
    ContentView()
}
