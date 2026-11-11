//
//  ContentView.swift
//  ViewCompositionDemos2
//
//  Created by Mohammad Azam on 10/20/25.
//

import SwiftUI

struct CircularProgressView: View {
    /// 0.0 ... 1.0
    var progress: CGFloat
    var lineWidth: CGFloat = 10
    var showsPercentage: Bool = true
    var roundedCaps: Bool = true
    var trackColor: Color = .gray.opacity(0.2)
    var gradient: AngularGradient = .init(
        gradient: .init(colors: [.blue, .purple, .pink, .blue]),
        center: .center
    )

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(trackColor, lineWidth: lineWidth)

            // Progress ring
            Circle()
                .trim(from: 0, to: max(0, min(1, progress)))
                .stroke(
                    gradient,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: roundedCaps ? .round : .butt
                    )
                )
                .rotationEffect(.degrees(-90)) // start at top
                .animation(.easeInOut(duration: 0.35), value: progress)

            if showsPercentage {
                Text("\(Int((max(0, min(1, progress)) * 100).rounded()))%")
                    //.font(.system(.title2, design: .rounded).monospacedDigit())
                    .bold()
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.2), value: progress)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int((max(0, min(1, progress)) * 100).rounded())) percent")
    }
}

struct Customer: Identifiable {
    let id = UUID()
    let name: String
    let imageURL: URL?
}

enum ViewPlacement {
    case leading
    case trailing
}

struct ListCellView<Leading: View, Trailing: View>: View {
    
    let title: String
    var subTitle: String?
    var description: String?
    var imageURL: URL?
    var imagePlacement: ViewPlacement = .leading
    @ViewBuilder var leadingAccessoryView: () -> Leading
    @ViewBuilder var trailingAccessoryView: () -> Trailing
    
    init(title: String, subTitle: String? = nil, description: String? = nil, imageURL: URL? = nil, imagePlacement: ViewPlacement = .leading, leadingAccessoryView: @escaping () -> Leading = { EmptyView() }, trailingAccessoryView: @escaping () -> Trailing = { EmptyView() }) {
        self.title = title
        self.subTitle = subTitle
        self.description = description
        self.imageURL = imageURL
        self.imagePlacement = imagePlacement
        self.leadingAccessoryView = leadingAccessoryView
        self.trailingAccessoryView = trailingAccessoryView
    }
    
    
    private var imageView: some View {
        AsyncImage(url: imageURL) { img in
            img.resizable()
                .frame(width: 50, height: 50)
        } placeholder: {
            ProgressView()
        }
    }
    
    var body: some View {
        HStack {
            
            leadingAccessoryView()
            
            if imagePlacement == .leading, imageURL != nil {
                imageView
            }
            
            VStack(alignment: .leading) {
                Text(title)
                if let subTitle {
                    Text(subTitle)
                        .font(.caption)
                }
            }
            Spacer()
            
            if imagePlacement == .trailing, imageURL != nil {
                imageView
            }
            
            trailingAccessoryView()
        }
    }
}

/*
struct CustomerCellView: View {
    
    let customer: Customer
    
    var body: some View {
        HStack {
            AsyncImage(url: customer.imageURL) { img in
                img.resizable()
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            
            Text(customer.name)
        }
    }
} */

struct CustomerListView: View {
    
    @State private var value: CGFloat = 0.25
    let customers: [Customer]
    
    var body: some View {
        List(customers) { customer in
            ListCellView(title: customer.name, subTitle: "1200 Richmond Ave, Houston, TX", imagePlacement: .leading, leadingAccessoryView: {
                CircularProgressView(progress: value)
                    .frame(width: 50, height: 50)
            })
        }
    }
    
}

struct ContentView: View {
    
    let customers: [Customer] = [
        .init(name: "Olivia Bennett", imageURL: URL(string: "https://randomuser.me/api/portraits/women/44.jpg")!),
        .init(name: "Noah Peterson", imageURL: URL(string: "https://randomuser.me/api/portraits/men/32.jpg")!),
        .init(name: "Amelia Davis", imageURL: URL(string: "https://randomuser.me/api/portraits/women/68.jpg")!),
        .init(name: "Liam Martinez", imageURL: URL(string: "https://randomuser.me/api/portraits/men/57.jpg")!),
        .init(name: "Emma Johnson", imageURL: URL(string: "https://randomuser.me/api/portraits/women/3.jpg")!)
    ]
    
    var body: some View {
       CustomerListView(customers: customers)
    }
}

#Preview {
    ContentView()
}


// MARK: - Helpers used in previews

private let sampleImageURL = URL(string: "https://picsum.photos/seed/azam/100")

private struct ToggleCell: View {
    @State private var isOn = true
    var body: some View {
        ListCellView(
            title: "Notifications",
            subTitle: "Marketing and product updates"
        ) {
            // leadingAccessoryView
            Image(systemName: "bell.badge")
                .font(.title3)
        } trailingAccessoryView: {
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 6)
    }
}

private struct ProgressPill: View {
    var progress: Double
    var body: some View {
        Text("\(Int(progress * 100))%")
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(.blue.opacity(0.15)))
    }
}

// MARK: - Previews

#Preview("Title only") {
    List {
        ListCellView(title: "Plain cell")
        ListCellView(title: "Another item")
    }
}

#Preview("With subtitle") {
    List {
        ListCellView(title: "AzamSharp School", subTitle: "Membership active")
        ListCellView(title: "Udemy", subTitle: "Course updates available")
    }
}

#Preview("Leading image (avatar)") {
    List {
        ListCellView(
            title: "Mohammad Azam",
            subTitle: "Instructor",
            imageURL: sampleImageURL,
            imagePlacement: .leading
        )
    }
}

#Preview("Trailing image (thumbnail)") {
    List {
        ListCellView(
            title: "Raywenderlich Article",
            subTitle: "SwiftUI Architecture",
            imageURL: sampleImageURL,
            imagePlacement: .trailing
        )
    }
}

#Preview("Leading icon + trailing chevron") {
    List {
        ListCellView(
            title: "Account",
            subTitle: "Security and login"
        ) {
            Image(systemName: "person.crop.circle.fill")
                .font(.title2)
        } trailingAccessoryView: {
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

#Preview("Trailing badge / pill") {
    List {
        ListCellView(
            title: "Inbox",
            subTitle: "New messages"
        ) {
            Image(systemName: "tray.full.fill")
                .font(.title3)
        } trailingAccessoryView: {
            Text("3")
                .font(.caption2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().fill(.red.opacity(0.15)))
        }
        .padding(.vertical, 6)
    }
}

#Preview("Toggle as trailing control") {
    List {
        ToggleCell()
    }
}

#Preview("Progress as trailing accessory") {
    List {
        ListCellView(
            title: "Video upload",
            subTitle: "Processing"
        ) {
            Image(systemName: "arrow.up.circle.fill")
                .font(.title3)
        } trailingAccessoryView: {
            ProgressPill(progress: 0.72)
        }
        .padding(.vertical, 6)
    }
}



#Preview("Dark mode") {
    NavigationStack {
        List {
            ListCellView(
                title: "Settings",
                subTitle: "All preferences"
            ) {
                Image(systemName: "gearshape.fill")
                    .font(.title3)
            } trailingAccessoryView: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Menu")
    }
    .environment(\.colorScheme, .dark)
}
