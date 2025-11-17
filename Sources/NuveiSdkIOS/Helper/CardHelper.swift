//
//  CardHelper.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 12/11/25.
//

import Foundation
import SwiftUI

public struct ExpiryDate {
    let month: Int
    let year: Int
}



public class CardHelper{
    init(){
        
    }
    
    
    
    static func formatExpiryDate(_ value: String)-> String{
        
         let digits = value.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
         var limited = String(digits.prefix(4))
         if !limited.isEmpty {
             var month = limited.count >= 2 ? String(limited.prefix(2)) : limited
             
             if month.count == 1, let m = Int(month), m > 1 {
                 month = "0" + month
                 if limited.count > 1 {
                     let startIndex = limited.index(limited.startIndex, offsetBy: 1)
                     limited = month + limited[startIndex...]
                 } else {
                     limited = month
                 }
             }
             
             if month.count == 2, let monthNum = Int(month) {
                 if monthNum < 1 || monthNum > 12 {
                     if limited.count > 1 {
                         let index = limited.index(limited.startIndex, offsetBy: 1)
                         return String(limited[index])
                     } else {
                         return ""
                     }
                 }
             }
         }
         
         if limited.count >= 3 {
             let month = String(limited.prefix(2))
             let yearStart = limited.index(limited.startIndex, offsetBy: 2)
             let year = String(limited[yearStart...])
             return "\(month)/\(year)"
         } else {
             return limited
         }
    }
    
    static func validateExpiryDate(_ expiry: String?) -> Bool {
        guard let expiry = expiry?.trimmingCharacters(in: .whitespaces), expiry.count == 5 else {
            return false
        }

        let parts = expiry.split(separator: "/")
        guard parts.count == 2,
              let month = Int(parts[0]),
              let year = Int(parts[1]),
              (1...12).contains(month) else {
            return false
        }

        let now = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: now) % 100 // últimos 2 dígitos
        let currentMonth = calendar.component(.month, from: now)

        if year < currentYear || (year == currentYear && month < currentMonth) {
            return false
        }

        return true // válido
    }
    
    
    public static func validateCardNumber(_ cardNumber: String) -> Bool {
        let cleaned = cardNumber.replacingOccurrences(of: "[\\s-]+", with: "", options: .regularExpression)
        guard !cleaned.isEmpty, cleaned.range(of: "^[0-9]+$", options: .regularExpression) != nil else {
            return false
        }

        var sum = 0
        var isEven = false
        for char in cleaned.reversed() {
            guard let digit = Int(String(char)) else { return false }

            var temp = digit
            if isEven {
                temp *= 2
                if temp > 9 {
                    temp -= 9
                }
            }

            sum += temp
            isEven.toggle()
        }
        return sum % 10 == 0
    }

    
    
   static func getCardInfo(for number: String) -> CardInfo {
        let cleanNumber = number.replacingOccurrences(of: " ", with: "")
        for card in cardTypes {
            let range = NSRange(location: 0, length: cleanNumber.utf16.count)
            if card.regex.firstMatch(in: cleanNumber, options: [], range: range) != nil {
                return card
            }
        }
        return CardInfo(
            type: "Unknown",
            regexPattern: "^$",
            mask: "#### #### #### ####",
            cvcNumber: 3,
            validLengths: [16],
            typeCode: "",
            iconName: "iconUnknown",
            gradientColors: [Color(.darkGray), Color(.black)]
        )
    }

   static func applyMask(to number: String) -> String {
        let cardInfo = CardHelper.getCardInfo(for: number)
        let cleanNumber = number.replacingOccurrences(of: " ", with: "")
        
        var result = ""
        var textIndex = cleanNumber.startIndex

        for char in cardInfo.mask {
            if textIndex == cleanNumber.endIndex { break }
            if char == "#" {
                result.append(cleanNumber[textIndex])
                textIndex = cleanNumber.index(after: textIndex)
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    
    
  static func parseExpiryDate(_ value: String) -> ExpiryDate? {
        
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        let parts = trimmed.split(separator: "/")
        guard parts.count == 2 else { return nil }
        
        
        guard let month = Int(parts[0]), month >= 1, month <= 12 else {
            return nil
        }
        
        var yearString = String(parts[1])
        
        
        guard yearString.count == 2 || yearString.count == 4 else { return nil }
        
        
        if yearString.count == 2 {
            yearString = "20" + yearString
        }
        
        guard let year = Int(yearString) else { return nil }
        
        
        guard year >= 2000 && year <= 2099 else { return nil }
        
        return ExpiryDate(month: month, year: year)
    }
}
