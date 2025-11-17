//
//  Blunde.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 7/11/25.
//
import Foundation

public extension Bundle{
    static var nuvei: Bundle{
        #if SWIFT_PACKAGE
        return .module
        #else
        return Bundle(for: Environments.self)
        #endif
    }
}
