//
//  BrowserInfoModel.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 13/11/25.
//


public struct BrowserInfo: Codable, Sendable {
    let ip: String
    let language: String
    let java_enabled: Bool
    let js_enabled: Bool
    let color_depth: Int
    let screen_height: Int
    let screen_width: Int
    let timezone_offset: Int
    let accept_header: String
    let user_agent: String
}
