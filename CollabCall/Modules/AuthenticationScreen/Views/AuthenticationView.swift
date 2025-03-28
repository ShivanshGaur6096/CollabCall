//
//  AuthenticationView.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 25/03/25.
//

import SwiftUI

struct LoginScreen: View {
    
    @State private var showSignInView: Bool = false
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            // TODO: Add Background Image and Logo etc.
            if isLoading {
                SplashScreenView()
            } else {
//                if showSignInView {
//                    AuthenticationView(showSignInView: $showSignInView)
//                } else {
//                    ProfileView(showSignInView: $showSignInView)
//                }
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        .task {
            await checkAuthentication()
        }
    }
    
    private func checkAuthentication() async {
        let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
        await MainActor.run {
            self.showSignInView = authUser == nil
            self.isLoading = false // Stop splash screen
        }
    }
}

struct AnimatedBreathingGradientView: View {
    @State private var animate = false
    @State private var startRadius: CGFloat = 50
    @State private var endRadius: CGFloat = 600
    
    var body: some View {
        RadialGradient(
            gradient: Gradient(colors: animate ? [Color.blue, Color.purple, Color.red] : [Color.orange, Color.yellow, Color.pink]),
            center: animate ? .topLeading : .bottomTrailing,
            startRadius: startRadius,
            endRadius: endRadius
        )
        .edgesIgnoringSafeArea(.all)
        .blur(radius: animate ? 20 : 10)
        .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animate)
        .onAppear {
            startRandomAnimation()
            animate.toggle()
        }
    }
    
    private func startRandomAnimation() {
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            startRadius = CGFloat.random(in: 40...60)
            endRadius = CGFloat.random(in: 550...650)
        }
    }
}

struct AuthenticationView: View {
    
    @StateObject var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Radial Gradient Background
//                AnimatedBreathingGradientView()
                
                VStack(spacing: 10) {
//                    AnimatedTextView()
                    
                    Spacer()
                    
                    // MARK: Google Sign-In Button View
                    Button {
                        Task {
                            do {
                                try await viewModel.signInGoogle()
                                showSignInView = false
                            } catch {
                                // TODO: Show Popup for any email sign-in error.
                                print("Error while google sign-in: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        HStack(alignment: .center, spacing: 20) {
                            Image(uiImage: .evalogo)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // Adjust size
                            
                            Text("Sign In with Google")
                                .font(.headline)
                                .foregroundStyle(Color(hex: "#FFFFFF"))
                        }
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#6200EA"))
                        .cornerRadius(10)
                    }
                    
                    // MARK: Sign-In with email-password Button View
                    NavigationLink {
                        SignInEmailView(showSignInView: $showSignInView, isRegistering: false)
                    } label: {
                        Text("Sign In with Email")
                            .font(.headline)
                            .foregroundStyle(Color(hex: "#B0BEC5"))
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#FF9100"))
                            .cornerRadius(10)
                    }
                    
                    NavigationLink {
                        SignInEmailView(showSignInView: $showSignInView, isRegistering: true)
                    } label: {
                        Text("Don't have an account? Sign Up")
                            .underline()
                            .font(.subheadline)
                            .tint(.gray)
                    }
                }
                .padding()
//                .navigationTitle("Sign In")
            }
            .onAppear {
                let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                self.showSignInView = authUser == nil
            }
        }
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
