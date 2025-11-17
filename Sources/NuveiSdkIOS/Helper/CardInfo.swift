//
//  CardInfo.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 12/11/25.
//



import SwiftUI

struct CardInfo {
    let type: String
    let regex: NSRegularExpression
    let mask: String
    let cvcNumber: Int
    let validLengths: [Int]
    let typeCode: String
    let icon: String?
    let gradientColors: [Color]

    init(
        type: String,
        regexPattern: String,
        mask: String,
        cvcNumber: Int,
        validLengths: [Int],
        typeCode: String,
        iconName: String,
        gradientColors: [Color]
    ) {
        self.type = type
        self.regex = try! NSRegularExpression(pattern: regexPattern)
        self.mask = mask
        self.cvcNumber = cvcNumber
        self.validLengths = validLengths
        self.typeCode = typeCode
        self.icon = iconName
        self.gradientColors = gradientColors
    }
}

let cardTypes: [CardInfo] = [
    CardInfo(
        type: "Visa",
        regexPattern: "^4",
        mask: "#### #### #### ####",
        cvcNumber: 3,
        validLengths: [13, 16, 19],
        typeCode: "vi",
        iconName: "cc_Visa",
        gradientColors: [
            Color(red: 0.1, green: 0.12, blue: 0.44),
            Color(red: 0.24, green: 0.36, blue: 0.96)
        ]
    ),
    CardInfo(
        type: "Mastercard",
        regexPattern: "^(5[1-5]|2[2-7])",
        mask: "#### #### #### ####",
        cvcNumber: 3,
        validLengths: [16],
        typeCode: "mc",
        iconName: "cc_MasterCard",
        gradientColors: [
            Color(red: 0.92, green: 0, blue: 0.1),
            Color(red: 0.97, green: 0.62, blue: 0.1)
        ]
    ),
    CardInfo(
        type: "American Express",
        regexPattern: "^3[47]",
        mask: "#### ###### #####",
        cvcNumber: 4,
        validLengths: [15],
        typeCode: "ax",
        iconName: "cc_Amex",
        gradientColors: [
            Color(red: 0.18, green: 0.47, blue: 0.73),
            Color(red: 0.12, green: 0.34, blue: 0.6)
        ]
    ),
    CardInfo(
        type: "Diners",
        regexPattern: "^3(0[0-5]|[68])",
        mask: "#### ###### ####",
        cvcNumber: 3,
        validLengths: [14],
        typeCode: "di",
        iconName: "stp_card_diners",
        gradientColors: [
            Color(red: 0, green: 0.42, blue: 0.63),
            Color(red: 0, green: 0.71, blue: 0.89)
        ]
    ),
    CardInfo(
        type: "Discover",
        regexPattern: "^(6011|65|64[4-9]|622)",
        mask: "#### #### #### ####",
        cvcNumber: 3,
        validLengths: [16, 19],
        typeCode: "dc",
        iconName: "iconDiscover",
        gradientColors: [
            Color(red: 1, green: 0.44, blue: 0),
            Color(red: 1, green: 0.56, blue: 0)
        ]
    ),
    CardInfo(
        type: "Maestro",
        regexPattern: "^(5[06789]|6)",
        mask: "#### #### #### ####",
        cvcNumber: 3,
        validLengths: [12, 13, 14, 15, 16, 17, 18, 19],
        typeCode: "ma",
        iconName: "stp_card_mastercard",
        gradientColors: [
            Color(red: 1, green: 0.44, blue: 0),
            Color(red: 1, green: 0.56, blue: 0)
        ]
    )
]


extension CardInfo {
    static func defaultCard() -> CardInfo {
        return CardInfo(
            type: "Unknown",
            regexPattern: "^$",
            mask: "#### #### #### ####",
            cvcNumber: 3,
            validLengths: [16],
            typeCode: "",
            iconName: "stp_card_unknown",
            gradientColors: [Color(.darkGray), Color(.black)]
        )
    }
    
    static func detect(from number: String) -> CardInfo {
            let sanitized = number.replacingOccurrences(of: " ", with: "")
            for card in cardTypes {
                let range = NSRange(location: 0, length: sanitized.utf16.count)
                if card.regex.firstMatch(in: sanitized, options: [], range: range) != nil {
                    return card
                }
            }
            return CardInfo.defaultCard()
        }
}
