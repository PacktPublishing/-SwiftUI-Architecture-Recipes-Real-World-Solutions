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
                PatientListScreen()
            case .detail(let id):
                Text("Patient Detail Screen \(id)")
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
                DoctorDetailScreen(id: id)
        }
    }
}

struct DoctorDetailScreen: View {
    
    let id: Int
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Doctor Detail")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.purple)
                .padding(.top)
            
            Text("Doctor ID: \(id)")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Name: Dr. Jane Doe")
                Text("Specialty: Cardiology")
                Text("Experience: 15 Years")
                Text("Location: SwiftUI Medical Center")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Doctor #\(id)")
    }
}

struct Patient: Identifiable, Hashable {
    let id: Int
    let name: String
    let age: Int
}

struct PatientListScreen: View {
    
    let patients: [Patient] = [
        Patient(id: 1, name: "Alice Smith", age: 34),
        Patient(id: 2, name: "Bob Johnson", age: 42),
        Patient(id: 3, name: "Carla Gomez", age: 28)
    ]
    
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        List(patients) { patient in
            Button {
                navigate(.patients(.detail(patient.id)))
            } label: {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text(patient.name)
                            .font(.headline)
                        Text("Age: \(patient.age)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Patients")
    }
}



struct PatientScreen: View {
    
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to the Patient Section")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.blue)

            Button(action: {
                navigate(.patients(.list))
            }) {
                Label("View Patient List", systemImage: "person.3.fill")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
        .navigationTitle("Patients")
    }
}


struct DoctorScreen: View {
    
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to the Doctor Section")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.purple)
            
            Button(action: {
                navigate(.doctors(.detail(2)))
            }) {
                Label("View Doctor Details", systemImage: "stethoscope")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple.opacity(0.2))
                    .foregroundColor(.purple)
                    .cornerRadius(12)
            }
            
            Button(action: {
                navigate(.patients(.list))
            }) {
                Label("View Patient List", systemImage: "heart.fill")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.2))
                    .foregroundColor(.red)
                    .cornerRadius(12)
            }
        }
        .padding()
        .navigationTitle("Doctor Screen")
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
