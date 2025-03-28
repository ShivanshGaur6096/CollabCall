//
//  SplashScreenView.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 26/03/25.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack {
            Image(.evalogo)
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            Text("CollabCall")
                .font(.largeTitle)
                .bold()
            ProgressView() // Loading Indicator
                .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    SplashScreenView()
}
