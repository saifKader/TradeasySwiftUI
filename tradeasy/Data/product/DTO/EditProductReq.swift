//
//  EditProductReq.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 16/4/2023.
//

import Foundation
import UIKit
struct EditProductReq {
    let prod_id: String
    let name: String
    let description: String
    let price: Double
    let category: String
    let quantity: Int
    let bid_end_date: String
    let forBid: Bool
    let image: UIImage
}
