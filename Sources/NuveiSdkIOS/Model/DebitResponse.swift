//
//  DebitResponse.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 11/11/25.
//




import Foundation

public struct DebitResponse: Codable, Sendable {
    public let transaction: TransactionData
    public let card: Card
    public let threeDS: ThreeDSData?

    enum CodingKeys: String, CodingKey {
        case transaction
        case card
        case threeDS = "3ds"
    }
}


public struct ThreeDSData: Codable, Sendable {
    public let sdk_response: SdkResponse?
    public let authentication: AuthenticationData?
    public let browser_response: BrowserResponse?
}

public struct SdkResponse: Codable, Sendable {
    public let acs_trans_id: String?
    public let acs_signed_content: String?
    public let acs_reference_number: String?
}

public struct AuthenticationData: Codable, Sendable {
    public let status: String?
    public let return_message: String?
    public let version: String?
    public let xid: String?
    public let reference_id: String?
    public let cavv: String?
    public let return_code: String?
    public let eci: String?
}

public struct BrowserResponse: Codable, Sendable {
    public let hidden_iframe: String?
    public let challenge_request: String?
}
