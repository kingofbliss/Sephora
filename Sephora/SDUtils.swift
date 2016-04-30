//
//  SDUtils.swift
//  Sephora
//
//  Created by payoda on 29/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import Foundation
import UIKit

class SDUtils: NSObject {
    
    func changeTabBadge(vc: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let tabArray = vc.tabBarController?!.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(2) as! UITabBarItem
        if (defaults.integerForKey(SDConstants.Keys.CartCount) > 0) {
            tabItem.badgeValue = String(defaults.integerForKey(SDConstants.Keys.CartCount))
        }
        else {
            tabItem.badgeValue = nil
        }
    }
    
    func showAlertandDismiss(vc:AnyObject, message:String)
    {
        let alert = UIAlertController(title: "Oops", message: SDConstants.ErrorMessages.NoItemsInCategory , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                vc.navigationController?!.popViewControllerAnimated(true)
            case .Cancel:
                print("cancel")
            case .Destructive:
                print("destructive")
            }
        }))
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
}