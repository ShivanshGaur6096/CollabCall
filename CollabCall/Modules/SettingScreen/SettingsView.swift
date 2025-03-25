//
//  SettingsView.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 24/03/25.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State private var userName: String = ""
    
    @State private var showLogoutAlert = false
    @State private var logOutAlertMessage = ""
    
    @State private var showResetAlert = false
    @State private var passwordResetAlertMessage = ""
    
    var body: some View {
        List {
            Button("Log out") {
                logOutAlertMessage = "\(userName) are you sure you want to log out from the app?"
                showLogoutAlert = true
            }
            .alert("Log-Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                
                Button("Confirm", role: .destructive) {
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                    } catch {
                        logOutAlertMessage = "Error while Log-Out: \(error)"
                        showLogoutAlert = true
                    }
                }
            } message: {
                Text(logOutAlertMessage)
            }
            
            if viewModel.authProviders.contains(.password) {
                Button("Reset Password") {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            passwordResetAlertMessage = "Password Reset Link has been sent to your registered email."
                            showResetAlert = true
                        } catch {
                            passwordResetAlertMessage = "Error Sending Password Reset Email: \(error.localizedDescription)"
                            showResetAlert = true
                        }
                    }
                }
                .alert("Reset Password", isPresented: $showResetAlert) {
                    Button("Done", role: .cancel) { }
                } message: {
                    Text(passwordResetAlertMessage)
                }
            }

        }
        .onAppear(perform: {
            Task {
                do {
                    userName = try await viewModel.fetchName()
                } catch {
                    print("Error while fetching name")
                }
            }
            
            viewModel.loadAuthProvider()
        })
        .navigationTitle("Hi, \(userName)")
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
