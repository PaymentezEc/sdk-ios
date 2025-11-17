//
//  AddCardModel.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 13/11/25.
//


public struct AddCardModel: Codable, Sendable{
    public let user: User
    public let card: Card
    public let extra_params: ExtraParams
}


public struct ExtraParams: Codable, Sendable{
    public let threeDS2_data: ThreeDS2_data
    public let browser_info: BrowserInfo?
}


public struct ThreeDS2_data: Codable, Sendable{
    public let term_url: String
    public let device_type: String
}





public struct AddCardResponse: Codable, Sendable {
    let card: Card
    let threeDS: ThreeDSData?
    let transaction: TransactionInfo

    enum CodingKeys: String, CodingKey {
        case card
        case threeDS = "3ds"
        case transaction
    }
}

public struct TransactionInfo: Codable, Sendable {
    let status_detail: Int?
}
