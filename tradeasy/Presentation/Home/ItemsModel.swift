//
//  ProductModel.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 6/4/2023.
//

import Foundation

struct Products: Codable, Identifiable {
    let id: UUID
    let name: String
    let price: Double
    let description: String
    let imageUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case description
        case imageUrl = "image_url"
    }
}

