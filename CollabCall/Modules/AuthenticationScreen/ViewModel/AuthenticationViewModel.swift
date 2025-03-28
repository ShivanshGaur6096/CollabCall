//
//  AuthenticationViewModel.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 24/03/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Firebase

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("no firbase clientID found")
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        //get rootView
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = scene?.windows.first?.rootViewController else {
            fatalError("There is no root view controller!")
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let user = result.user
        
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(idToken: idToken,
                                                                                     accessToken: user.accessToken.tokenString)
        let dbDataUser = DBUser(authData: authDataResult)
        try await UserManager.shared.createUser(user: dbDataUser)
    }
}
