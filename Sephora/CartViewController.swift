//
//  CartViewController.swift
//  Sephora
//
//  Created by payoda on 27/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "My Cart"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addProductToCart() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(defaults.integerForKey(SDConstants.Keys.CartCount)+1, forKey: SDConstants.Keys.CartCount)
    }
    
    @IBAction func emptyCart() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(0, forKey: SDConstants.Keys.CartCount)
        SDUtils().changeTabBadge(self)
    }
}

