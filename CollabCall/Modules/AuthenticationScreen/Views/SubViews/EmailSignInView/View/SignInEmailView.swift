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
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Passowrd", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        self.showSignInView = false
                        /// In case of succrssfully signUp of user `return` get hit and we will be put of Task
                        /// else `signIn` will get called as we won't be out of function
                        return
                    } catch {
                        print("Sign Up Errro: \(error)")
                    }
                    
                    do {
                        try await viewModel.signIn()
                        self.showSignInView = false
                        return
                    } catch {
                        print("Sign In Errro: \(error)")
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
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
