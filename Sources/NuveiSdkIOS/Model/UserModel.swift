//
//  UserModel.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 11/11/25.
//

public struct User: Codable, Sendable {
    let id: String
    let email: String?

    init(id: String, email: String? = nil) {
        self.id = id
        self.email = email
    }
}
