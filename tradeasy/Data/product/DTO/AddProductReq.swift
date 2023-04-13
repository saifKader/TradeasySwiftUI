//
//  AddProductReq.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 12/4/2023.
//

import Foundation
import UIKit

struct AddProductReq {
    let name: String
    let description: String
    let price: Double
    let image: UIImage
    let category: String
    let quantity: Int
    let bid_end_date: String
    let forBid: Bool
}



