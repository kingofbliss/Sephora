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
        let tabArray = vc.tabBarController?!.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(2) as! UITabBarItem
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        print(appDelegate.productArray.count)
        if (appDelegate.productArray.count) > 0 {
            tabItem.badgeValue = String(appDelegate.productArray.count)
        }
        else {
            tabItem.badgeValue = nil
        }
    }
    
    func showAlertandDismiss(vc:AnyObject, message:String)
    {
        let alert = UIAlertController(title: "Oops", message: message , preferredStyle: UIAlertControllerStyle.Alert)
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
    
    func showAlert(vc:AnyObject, message:String)
    {
        let alert = UIAlertController(title: "Oops", message: message , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                print("Default")
            case .Cancel:
                print("cancel")
            case .Destructive:
                print("destructive")
            }
        }))
        vc.presentViewController(alert, animated: true, completion: nil)
    }

    
}