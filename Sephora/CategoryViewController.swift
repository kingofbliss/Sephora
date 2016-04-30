//
//  FirstViewController.swift
//  Sephora
//
//  Created by payoda on 27/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController , UITableViewDelegate {

    var categoriesArray:NSArray = []
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        SDUtils().changeTabBadge(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        categoriesArray = SDConstants.Others.CategoryArray
        self.navigationItem.title = "Sephora"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableview Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("customcell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = categoriesArray[indexPath.row] as? String
        
        return cell
    }

    //MARK: - UITableview Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        loadProductListVC((categoriesArray[indexPath.row] as? String)!)
        
    }
    
    /**
     Load Product List VC based on category
     
     - parameter categoryTitle: Selected Category
     */
    
    func loadProductListVC(categoryTitle:String) {
        let productListVC = self.storyboard?.instantiateViewControllerWithIdentifier("productListViewController") as! ProductListViewController
        productListVC.categoryTitle = categoryTitle
        self.navigationController?.pushViewController(productListVC, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

