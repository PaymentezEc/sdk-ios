//
//  CardListResponse.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 7/11/25.
//


public struct CardListResponse: Codable, Sendable {
   public let cards: [Card]
   public let result_size: Int
}


