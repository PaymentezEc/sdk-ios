//
//  TransactionModel.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 11/11/25.
//


public struct TransactionData: Codable, Sendable {
    public let amount: Double?
    public let authorization_code: String?
    public let carrier: String?
    public let carrier_code: String?
    public let current_status: String?
    public let dev_reference: String?
    public let id: String?
    public let installments: Int?
    public let installments_type: String?
    public let message: String?
    public let payment_date: String?
    public let payment_method_type: String?
    public let product_description: String?
    public let status: String?
    public let status_detail: Int?
    
    public let refund_amount: Double?
    public let reference_label: String?
    
    public init(
        amount: Double? = nil,
        authorization_code: String? = nil,
        carrier: String? = nil,
        carrier_code: String? = nil,
        current_status: String? = nil,
        dev_reference: String? = nil,
        id: String? = nil,
        installments: Int? = nil,
        installments_type: String? = nil,
        message: String? = nil,
        payment_date: String? = nil,
        payment_method_type: String? = nil,
        product_description: String? = nil,
        status: String? = nil,
        status_detail: Int? = nil,
        refund_amount: Double? = nil,
        reference_label: String? = nil
    ) {
        self.amount = amount
        self.authorization_code = authorization_code
        self.carrier = carrier
        self.carrier_code = carrier_code
        self.current_status = current_status
        self.dev_reference = dev_reference
        self.id = id
        self.installments = installments
        self.installments_type = installments_type
        self.message = message
        self.payment_date = payment_date
        self.payment_method_type = payment_method_type
        self.product_description = product_description
        self.status = status
        self.status_detail = status_detail
        self.refund_amount = refund_amount
        self.reference_label = reference_label
    }
}
