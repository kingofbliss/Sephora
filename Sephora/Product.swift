//
//  Product.swift
//  Sephora
//
//  Created by payoda on 27/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import UIKit

class Product: NSObject {
    
    var productId: Int?
    var productName: String?
    var productDescription: String?
    var productCategory: String?
    var productPrice: NSNumber?
    var productImgUrl: String?
    var productOnSale: Bool?
    var productImageData:NSData?

    init(json: [String: AnyObject]) {
        super.init()
        self.productId = json["id"] as? Int
        self.productName = json["name"] as? String
        self.productDescription = json["description"] as? String
        self.productCategory = json["category"] as? String
        self.productPrice = json["price"] as? NSNumber
        self.productImgUrl = json["img_url"] as? String
        self.productOnSale = json["under_sale"] as? Bool
    }
}

