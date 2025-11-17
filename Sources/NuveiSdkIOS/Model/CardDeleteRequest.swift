//
//  CardDeleteRequest.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 11/11/25.
//

public struct DeleteCardRequest: Codable {
    public let card: Card
    public let user: User
}
