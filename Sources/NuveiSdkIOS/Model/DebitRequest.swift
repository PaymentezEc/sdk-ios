//
//  Untitled.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 11/11/25.
//


public struct DebitRequest: Codable {
    public let user: User
    public let order: OrderRequest
    public let card: Card
    
    public init(user: User, order: OrderRequest, card: Card) {
        self.user = user
        self.order = order
        self.card = card
    }
}


public struct OrderRequest: Codable, Sendable {
    public let amount: Double
    public let description: String?
    public let dev_reference: String?
    public let vat: Double?
    public let taxable_amount: Double?
    public let tax_percentage: Double?
    
    public init(
    amount: Double,
    description: String? = nil,
        dev_reference: String? = nil,
        vat: Double = 0,
        taxable_amount: Double = 0,
        tax_percentage: Double = 0
    ) {
        self.amount = amount
        self.description = description
        self.dev_reference = dev_reference
        self.vat = vat
        self.taxable_amount = taxable_amount
        self.tax_percentage = tax_percentage
    }
}
