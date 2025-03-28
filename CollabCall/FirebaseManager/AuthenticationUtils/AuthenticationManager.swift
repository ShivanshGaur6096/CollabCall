//
//  AuthenticationManager.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 24/03/25.
//

import Foundation
import FirebaseAuth

import GoogleSignIn
import GoogleSignInSwift

enum UserAuthMethod: String {
    case anonymous = "anonymous"
    case password = "password"
    case google = "google.com"
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    // MARK: Common Utility and Functions Mandatory Functons
    
    /// Fetch authenticated user within the app
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    /// Help to know what authentication method user
    func getProviders() throws -> [UserAuthMethod] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [UserAuthMethod] = []
        for provider in providerData {
            if let options = UserAuthMethod(rawValue: provider.providerID) {
                providers.append(options)
            } else {
                print("Auth Method not found: \(provider.providerID)")
            }
        }
        return providers
    }
    
    /// Get user sign-out from any method of Firebase liogin
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

// MARK: Email Login
extension AuthenticationManager {
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}

// MARK: Google Sign-In
extension AuthenticationManager {
 
    @discardableResult
    func signInWithGoogle(idToken: String, accessToken: String) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        return try await signInWithCred(with: credential)
    }
    
    func signInWithCred(with credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
