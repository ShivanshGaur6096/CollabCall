//
//  AnimatedTextView.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 28/03/25.
//

import SwiftUI

struct AnimatedTextView: View {
    @State private var text: String = ""
    @State private var backgroundColor: Color = .yellow
    @State private var foregroundColor: Color = .black
    
    private let stages: [(String, Color, Color)] = [
        ("Welcome,\n to CollabCall", .yellow, .black),
        ("Connect with your\ncolleagues\nfriends\nconnections...", .yellow, .black),
//        ("Connect with your\nfriends", .red, .white),
//        ("Connect with your\nconnections...", .orange, .black),
        ("Just Sign In\nor Sign Up yourself", .green, .white)
    ]
    
    @State private var stageIndex = 0
    @State private var charIndex = 0
    @State private var isDeleting = false
    
    var body: some View {
        VStack {
            Text(text)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding()
//                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(8)
//                .padding(.leading, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onAppear(perform: startTyping)
        }
    }
    
    private func startTyping() {
        guard stageIndex < stages.count else { return }
        
        let currentText = stages[stageIndex].0
        backgroundColor = stages[stageIndex].1
        foregroundColor = stages[stageIndex].2
        
        if !isDeleting {
            if charIndex < currentText.count {
                charIndex += 1
                text = String(currentText.prefix(charIndex))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    startTyping()
                }
            } else {
                // Wait before starting backspacing (except the last stage)
                if stageIndex < stages.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        isDeleting = true
                        startTyping()
                    }
                }
            }
        } else {
            if charIndex > 0 {
                charIndex -= 1
                text = String(currentText.prefix(charIndex))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    startTyping()
                }
            } else {
                // Move to next stage
                isDeleting = false
                stageIndex += 1
                startTyping()
            }
        }
    }
}

// MARK: Main View
struct MainView: View {
    var body: some View {
        NavigationStack {
            //            ZStack {
            //                AnimatedBreathingGradientView()
            
            VStack(spacing: 10) {
                AnimatedTextView()
            }
            //            }
        }
    }
}

#Preview {
//    MainView()
    AnimatedTextView()
}

