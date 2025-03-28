//
//  SignInEmailViewModel.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 24/03/25.
//

import Foundation

final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password required")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email,
                                                                               password: password)
        
        let dbDataUser = DBUser(userID: authDataResult.uid,
                                lastActive: Date(),
                                email: authDataResult.email,
                                name: self.name,
                                photoUrl: authDataResult.photoUrl,
                                preferences: nil)
        
        try await UserManager.shared.createUser(user: dbDataUser)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password required")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
}
