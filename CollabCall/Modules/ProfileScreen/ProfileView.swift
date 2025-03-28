//
//  ProfileView.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 25/03/25.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published var users: [DBUser] = []
    
    func loadCurrentUser() async throws {
        // TODO: Save user-id in UserDefault and use it everywhere
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func toggleLastSeenTime() {
        guard var user else { return }
        user.updateUserLastSeen()
        Task {
            try await UserManager.shared.updateData(for: user)
            self.user = try await UserManager.shared.getUser(userId: user.id)
        }
    }
    
    func addUserPreferences(pref: String) {
        guard let user else { return }
        Task {
            try await UserManager.shared.updateUserPreference(action: .update, for: user.id, with: pref)
            self.user = try await UserManager.shared.getUser(userId: user.id)
        }
    }
    
    func removeUserPreferences(pref: String) {
        guard let user else { return }
        Task {
            try await UserManager.shared.updateUserPreference(action: .remove, for: user.id, with: pref)
            self.user = try await UserManager.shared.getUser(userId: user.id)
        }
    }
    
    func getListOfUsers() {
        Task {
            self.users = try await UserManager.shared.fetchListOfUsers()
            print("Users Count: \(users.count)")
        }
    }
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    let prefrencesOptions = ["Hi", "How", "Are", "You"]
    
    var body: some View {
        List {
            userInfoSection()
            userPreferencesSection()
            usersListSection()
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .onAppear {
            viewModel.getListOfUsers()
        }
        .navigationTitle("Database")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
//                NavigationLink {
//                    SettingsView(showSignInView: $showSignInView)
//                } label: {
//                    Image(systemName: "gear")
//                        .font(.headline)
//                }
                
                Button {
                    // Action for logout
                    print("Button Tapped")
                } label: {
                    Text("Logout")
                        .padding()
                        .font(.headline)
//                        .background(Color.red.opacity(0.4))
//                        .foregroundStyle(Color.white)
                        .buttonStyle(.bordered)
                        .tint(.red)
                }

            }
        }
    }
    
    /// Displays the user info section
    @ViewBuilder
    private func userInfoSection() -> some View {
        if let user = viewModel.user {
            Section(header: Text("User Info")) {
                Text("User ID: \(user.id)")
                
                if let lastActive = user.lastActive {
                    Text("Last Active: \(lastActive)")
                }
                
                if let name = user.name {
                    Text("Name: \(name)")
                }
                
                if let email = user.email {
                    Text("Email: \(email)")
                }
                
                Button {
                    viewModel.toggleLastSeenTime()
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("New Last Seen")
                        
                        if let lastActive = user.lastActive {
                            Text("\(lastActive)")
                                .foregroundStyle(Color.green)
                        }
                    }
                }
            }
        }
    }
    
    /// Displays the user preferences section
    @ViewBuilder
    private func userPreferencesSection() -> some View {
        if let user = viewModel.user {
            Section(header: Text("Preferences")) {
                HStack {
                    ForEach(prefrencesOptions, id: \.self) { button in
                        Button(button) {
                            if user.preferences?.contains(button) ==  true {
                                viewModel.removeUserPreferences(pref: button)
                            } else {
                                viewModel.addUserPreferences(pref: button)
                            }
                        }
                        .font(.headline)
                        .buttonStyle(.borderedProminent)
                        .tint(user.preferences?.contains(button) ==  true ? Color.green : Color.blue)
                    }
                }
                
                HStack {
                    Text("Pref: ")
                        .font(.caption)
                    ForEach(user.preferences ?? ["NA"], id: \.self) { pref in
                        Text(pref)
                            .font(.caption)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    /// Displays the list of users
    @ViewBuilder
    private func usersListSection() -> some View {
        Section(header: Text("Users List")) {
            ForEach(viewModel.users) { user in
                Text(user.name ?? "NA")
            }
        }
    }
}

#Preview {
    ProfileView(showSignInView: .constant(false))
}
