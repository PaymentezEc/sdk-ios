//
//  Environments.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 3/11/25.
//

import Foundation

public struct EnvironmentConfig: Sendable {
    public let appCode: String
    public let appKey: String
    public let serverCode: String
    public let serverKey: String
    public let clientCode: String
    public let clientKey: String
    public let testMode: Bool
    
    public init(
        appCode: String,
        appKey: String,
        serverCode: String,
        serverKey: String,
        clientCode: String,
        clientKey: String,
        testMode: Bool = true
    ) {
        self.appCode = appCode
        self.appKey = appKey
        self.serverCode = serverCode
        self.serverKey = serverKey
        self.clientCode = clientCode
        self.clientKey = clientKey
        self.testMode = testMode
    }
}



@MainActor
public final class Environments {
    public static let shared = Environments()
    
    private(set) var config: EnvironmentConfig?
    private init(){}
    
    public func initialize(with config: EnvironmentConfig) throws {
        guard self.config == nil else {
            throw ErrorModel(error: ErrorData(type: "", help: "", description: ""))
        }
        self.config = config
        print(config)
    }
    
    
    public func getConfig() throws -> EnvironmentConfig {
           guard let config = self.config else {
               throw ErrorModel(error: ErrorData(type: "Error environment", help: "", description: "Environment not initialized"))
           }
           return config
       }
    

    
   
}
