//
//  Constants.swift
//  Sephora
//
//  Created by payoda on 27/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import UIKit

struct SDConstants {
    
    struct Webservice {
        static let SDBaseURL = "http://sephora-mobile-takehome-2.herokuapp.com/api/v1"
        static let SDGetProductbyCat = "/products.json?category="
    }
    
    struct Colors{
        static let NavigationBarColor = UIColor.whiteColor()
        static let NavigationTitleColor = UIColor.blackColor()
    }
    
    struct ErrorMessages {
        static let ItemNotFound = "No product found"
        static let NoItemsInCategory = "No products found for this category"
    }
    
    struct Keys {
        static let CartCount = "cartCount"
        static let Products = "products"
    }
    
    struct Others {
        static let CategoryArray = ["Makeup", "Skincare", "Hair", "Tools", "Nails", "Bath & Body", "Men"]
    }
    
}
