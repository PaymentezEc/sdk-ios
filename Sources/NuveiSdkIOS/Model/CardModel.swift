//
//  CardModel.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 11/11/25.
//

public struct Card: Codable, Sendable {

    public let bin: String?
    public let status: String?
    public let token: String?
    public let holder_name: String?
    
    public let expiry_year: NumberOrString?
    public let expiry_month: NumberOrString?

    public let transaction_reference: String?
    public let type: String?
    public let number: String?
    public let cvc: String?

    public init(
        bin: String? = nil,
        status: String? = nil,
        token: String? = nil,
        holder_name: String? = nil,
        expiry_year: NumberOrString? = nil,
        expiry_month: NumberOrString? = nil,
        transaction_reference: String? = nil,
        type: String? = nil,
        number: String? = nil,
        cvc: String? = nil
    ) {
        self.bin = bin
        self.status = status
        self.token = token
        self.holder_name = holder_name
        self.expiry_year = expiry_year
        self.expiry_month = expiry_month
        self.transaction_reference = transaction_reference
        self.type = type
        self.number = number
        self.cvc = cvc
    }
}




public enum NumberOrString: Codable, Sendable {
    case int(Int)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(
                NumberOrString.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Expected Int or String")
            )
        }
    }

   public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }

   public var stringValue: String {
        switch self {
        case .int(let v): return String(v)
        case .string(let v): return v
        }
    }
}
