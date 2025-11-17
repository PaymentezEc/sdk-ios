//
//  GlobalHelper.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 5/11/25.
//


import Foundation
import CommonCrypto
import UIKit

public class GlobalHelper{
    
    
    static func generateAuthToken(key:String, code: String) ->String {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let uniqueToken = generateUniqueToken(key: key, timestamp: timestamp)
        let authToken = "\(code);\(timestamp);\(uniqueToken)"
        let base64Token = Data(authToken.utf8).base64EncodedString()
        return base64Token.trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
    
    
    private static func generateUniqueToken(key :String, timestamp:String)->String{
        
                let input = key + timestamp
                guard let inputData = input.data(using: .utf8) else {
                    print("Error in conversion data")
                    return ""
                }
                var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
                inputData.withUnsafeBytes { buffer in
                    _ = CC_SHA256(buffer.baseAddress, CC_LONG(buffer.count), &digest)
                }
                let hexString = digest.map { String(format: "%02hhx", $0) }.joined()
                print("UNIQ-TOKEN (SHA-256): '\(hexString)'")
                return hexString
    }
    
    
    
    static func getBrowserInfo() async -> BrowserInfo? {
        
        guard let ip = await fetchPublicIP() else { return nil }


        let language = Locale.current.language.languageCode?.identifier ?? "en"

        
        let screen = await UIScreen.main
        let width = await Int(screen.bounds.width)
        let height = await Int(screen.bounds.height)

        
        let tz = TimeZone.current.secondsFromGMT() / 3600

        return await BrowserInfo(
            ip: ip,
            language: language,
            java_enabled: false,
            js_enabled: true,
            color_depth: 24,
            screen_height: height,
            screen_width: width,
            timezone_offset: tz,
            accept_header: "text/html",
            user_agent: defaultUserAgent()
        )
    }
    
    private static func fetchPublicIP() async -> String? {
        guard let url = URL(string: "https://api.ipify.org/?format=json") else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let object = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return object?["ip"] as? String
        } catch {
            return nil
        }
    }

    @MainActor
    private static func defaultUserAgent() -> String {
        let device = UIDevice.current
        let version = device.systemVersion.replacingOccurrences(of: ".", with: "_")

        return "Mozilla/5.0 (\(device.model); CPU iPhone OS \(version) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile"
    }
}
