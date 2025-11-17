//
//  ErrorModel.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 3/11/25.
//


import Foundation


public struct ErrorModel: Codable, Error, Sendable {
    public let error: ErrorData
    
    public init(error: ErrorData) {
        self.error = error
    }
}

public struct ErrorData: Codable, Sendable {
    public let type: String
    public let help: String
    public let description: String
    
    public init(type: String, help: String, description: String) {
        self.type = type
        self.help = help
        self.description = description
    }
}
