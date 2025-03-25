//
//  AuthenticationView.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 25/03/25.
//

import SwiftUI

struct AuthenticationView: View {
   
    @StateObject var viewModel = AuthenticationViewModel()
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    // MARK: In case of user already Auth
                    ProfileView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                VStack(spacing: 6) {
                    
                    // MARK: Sign-In with email-password Button View
                    NavigationLink {
                        SignInEmailView(showSignInView: $showSignInView)
                    } label: {
                        Text("Sign In with Email")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    
                    // MARK: Google Sign-In Button View
                    Button {
                        Task {
                            do {
                                try await viewModel.signInGoogle()
                                showSignInView = false
                            } catch {
                                print("Error while google sign-in: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        Text("Sign In with Google")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                }
                .padding()
                .navigationTitle("Sign In")
            }
        }
    }
}

#Preview {
    NavigationStack {
        AuthenticationView()
    }
}
