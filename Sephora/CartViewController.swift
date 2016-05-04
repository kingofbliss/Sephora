//
//  CartViewController.swift
//  Sephora
//
//  Created by payoda on 27/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import UIKit

class CartViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var cartListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "My Cart"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view, typically from a nib.
        cartListView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //pass the product obj
    func addProductToCart(product:Product) -> Bool {
        //Temp arr for store the products and use it as datasource
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(defaults.integerForKey(SDConstants.Keys.CartCount)+1, forKey: SDConstants.Keys.CartCount)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.productArray.contains(product)
        {
            return false
        }
        else{
            appDelegate.productArray.append(product)
        }
        return true
    }

    @IBAction func emptyCart() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(0, forKey: SDConstants.Keys.CartCount)
        SDUtils().changeTabBadge(self)
    }
    
    /* To - Do
     
     1. Change the ui design for cart view controller
     2. Change the methods
     3. Implement table view delegates
     
     */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.productArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as UITableViewCell
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let product = appDelegate.productArray[indexPath.row]
        cell.imageView?.image = UIImage(data: product.productImageData!)
        cell.textLabel?.text = product.productName
        cell.detailTextLabel?.text = "S$"+(product.productPrice?.stringValue)!

        return cell
    }

}

class CartListViewCell : UITableViewCell
{
    @IBOutlet weak var productImageView : UIImage!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var priceLabel : UILabel!
}


