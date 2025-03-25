//
//  SettingsViewModel.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 24/03/25.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [UserAuthMethod] = []
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func fetchName() async throws -> String {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let name = authUser.name else {
            return authUser.email ?? authUser.uid
        }
        return name
    }
    
    func loadAuthProvider() {
        if let provider = try? AuthenticationManager.shared.getProviders() {
            authProviders = provider
        }
    }
}
