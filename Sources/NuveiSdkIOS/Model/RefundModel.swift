//
//  RefundResponse.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 11/11/25.
//

public struct RefundResponse: Codable, Sendable{
    public let status: String
    public let transaction: TransactionData
    public let detail: String
    public let card: Card
}


public struct RefunRequest: Codable, Sendable{
    public let transaction: TransactionData
    public let order: OrderRequest
    public let more_info: Bool
}




