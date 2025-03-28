//
//  HomeScreen.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 28/03/25.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                List {
                    Text("Name")
                    Text("Age")
                    Text("Class")
                    Text("Work")
                    Text("Name")
                    Text("Age")
                    Text("Class")
                    Text("Work")
                    Text("Name")
                    Text("Age")
                    Text("Class")
                    Text("Work")
                }
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    Text("Hello 2, World!")
                    Text("Hello 3, World!")
                    Text("Hello 4, World!")
                    Text("Name")
                    Text("Age")
                    Text("Class")
                    Text("Work")
                    Text("Name")
                    Text("Age")
                    Text("Class")
                    Text("Work")
                    Text("Name")
                    Text("Age")
                    Text("Class")
                    Text("Work")
                }
            }
        }
        .navigationTitle("Shivansh")
        .padding()
    }
}

#Preview {
    NavigationStack {
        HomeScreen()
    }
}
