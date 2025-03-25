//
//  ConnectionsListView.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 25/03/25.
//

import SwiftUI

struct ConnectionsListView: View {
    let friendsList = ["Shivansh", "ABC", "Xyz", "mmm", "qrt"]
    var body: some View {
        List {
            ForEach(friendsList, id: \.self) { user in
                NavigationLink(destination:
                                Text("Hey!! \n\(user)")
                    .font(.headline)
                    .foregroundStyle(Color.black)
                ){
                    Text("Hello, \(user)")
                }
            }
        }
        .navigationTitle("Connections")
    }
}

#Preview {
    NavigationStack {
        ConnectionsListView()
    }
}
