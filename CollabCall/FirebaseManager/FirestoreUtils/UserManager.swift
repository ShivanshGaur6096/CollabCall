//
//  UserManager.swift
//  CollabCall
//
//  Created by Shivansh Gaur on 26/03/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct DBUser: Codable, Identifiable {
    let id: String
    var lastActive: Date? // TODO: Show last seen for user
    let email: String?
    let name: String?
    let photoUrl: String?
    let preferences: [String]?
    
    init(userID: String,
         lastActive: Date?,
         email: String?,
         name: String?,
         photoUrl: String?,
         preferences: [String]?) {
        self.id = userID
        self.lastActive = lastActive
        self.email = email
        self.name = name
        self.photoUrl = photoUrl
        self.preferences = preferences
    }
    
    // Using: Convenience Initializers
    init(authData: AuthDataResultModel) {
        self.id = authData.uid
        self.lastActive = Date()
        self.email = authData.email
        self.name = authData.name
        self.photoUrl = authData.photoUrl
        self.preferences = nil
    }
    
    /// It updates the last seen status of user
    mutating func updateUserLastSeen() {
        lastActive = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case lastActive = "last_active"
        case email = "email"
        case name = "name"
        case photoUrl = "profile_picture"
        case preferences = "preferences"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.lastActive, forKey: .lastActive)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.lastActive = try container.decodeIfPresent(Date.self, forKey: .lastActive)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
    }
}

enum AlterOperations {
    case update
    case remove
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    
    /// Create entry in database for new log-in user with his user-id
    func createUser(user: DBUser) async throws {
        try userDocument(userID: user.id).setData(from: user)
    }
    
    /// Fetch the existing users from the database
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userID: userId).getDocument(as: DBUser.self)
    }
    
    func updateData(for user: DBUser) async throws {
        try userDocument(userID: user.id).setData(from: user, merge: true)
    }
    
    func updateUserPreference(action: AlterOperations, for userId: String, with pref: String) async throws {
        switch action {
        case .update:
            let updatedData: [String:Any] = [
                DBUser.CodingKeys.preferences.rawValue: FieldValue.arrayUnion([pref])
            ]
            try await userDocument(userID: userId).updateData(updatedData)
            
        case .remove:
            let updatedData: [String:Any] = [
                DBUser.CodingKeys.preferences.rawValue: FieldValue.arrayRemove([pref])
            ]
            try await userDocument(userID: userId).updateData(updatedData)
        }
    }
    
    /// Fetch list of users registered
    func fetchListOfUsers() async throws -> [DBUser] {
        let snapshot = try await userCollection.getDocuments()
        return snapshot.documents.compactMap { documents in
            try? documents.data(as: DBUser.self)
        }
    }
}
