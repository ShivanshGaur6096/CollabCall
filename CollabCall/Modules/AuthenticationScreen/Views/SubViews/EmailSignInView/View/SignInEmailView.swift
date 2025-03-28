//
//  SignInEmailView.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 24/03/25.
//

import SwiftUI

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    @State var isRegistering: Bool = false
    @State private var confirmPassword: String = ""
    @State private var showPasswordRules: Bool = false
    
    private var isFormValid: Bool {
        if isRegistering {
            return !viewModel.email.isEmpty &&
            !viewModel.password.isEmpty &&
            !confirmPassword.isEmpty &&
            viewModel.password == confirmPassword &&
            viewModel.password.count >= 6
        } else {
            return !viewModel.email.isEmpty && !viewModel.password.isEmpty
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .autocapitalization(.none) // Prevents automatic capitalization
                .textInputAutocapitalization(.never) // Ensures iOS does not capitalize input
            
            SecureField("Passowrd", text: $viewModel.password, onCommit: {
                showPasswordRules = true
            })
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            if showPasswordRules {
                VStack(alignment: .leading, spacing: 4) {
                    Text("• Min. 6 characters")
                    Text("• At least 1 uppercase & 1 lowercase")
                    Text("• At least 1 number or symbol")
                }
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 10)
            }
            
            if isRegistering {
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                TextField("Full Name", text: $viewModel.name)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
            }
            
            // Add: Did you have an account? show Toggle text to get user registered and change isRegistering
            
            // TODO: Button wont be active for login until
            Button {
                Task {
                    do {
                        if isRegistering {
                            try await viewModel.signUp()
                        } else {
                            try await viewModel.signIn()
                        }
                        self.showSignInView = false
                    } catch {
                        print("Sign In Error: \(error)")
                    }
                }
            } label: {
                Text(isRegistering ? "Sign Up": "Sign In")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(isFormValid ? .blue : .gray)
                    .cornerRadius(10)
            }
            .disabled(!isFormValid) // Disable button until fields are filled correctly
            
            // Toggle between Sign In and Sign Up
            Button {
                isRegistering.toggle()
                confirmPassword = ""
                showPasswordRules = false
            } label: {
                Text(isRegistering ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.top, 5)
            }
            
        }
        .padding()
        .navigationTitle("Sign In with Email")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
