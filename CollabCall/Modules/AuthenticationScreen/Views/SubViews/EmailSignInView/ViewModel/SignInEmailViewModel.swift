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
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password required")
            return
        }
        
        let returnUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
        print(returnUserData)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password required")
            return
        }
        
        let returnUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
}
