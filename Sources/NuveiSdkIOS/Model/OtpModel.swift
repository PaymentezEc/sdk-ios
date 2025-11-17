//
//  OtpModel.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 12/11/25.
//

import Foundation

public struct OtpRequest: Codable, Sendable{
    public let type :String
    public let value: String
    public let more_info: Bool
    public let user: User
    public let transaction: TransactionData
}


public struct OtpResponse: Codable, Sendable {
    public let transaction: TransactionData
    public let card: Card
    public let threeDS: ThreeDSData

    enum CodingKeys: String, CodingKey {
        case transaction
        case card
        case threeDS = "3ds"
    }
}


