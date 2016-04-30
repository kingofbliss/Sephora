//
//  WebServiceLayer.swift
//  Sephora
//
//  Created by payoda on 27/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import UIKit
import Alamofire

typealias WebserviceHandler = (json: AnyObject? , error : NSError?)  -> Void

typealias ProductsCompletionHandler = (product :Product?, error: NSError?) -> Void
typealias ProductListCompletionHandler = (productArr :NSMutableArray?, error: NSError?) -> Void

class SDWebServiceLayer: NSObject {
    
    var baseUrl: String
    
    override init() {
        baseUrl = SDConstants.Webservice.SDBaseURL
        super.init()
        //Initialize here
        
    }
    
    func callWebServiceForURL(url: String, parameters: [String : AnyObject]?,headers: [String: String]?,method:String, handler:WebserviceHandler) {
        
        if method == "GET" {
            Alamofire.request(.GET, url, headers:headers, parameters: parameters)
                .responseJSON { response in
                  
                    if let JSON = response.result.value {
                        handler(json: JSON, error: nil)
                    } else {
                        handler(json: nil, error: NSError(domain:"Error", code: 0, userInfo: nil))
                    }
            }
            
        } else if method == "POST" {
            
            Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON, headers: headers) .responseJSON { response in
                
                if let JSON = response.result.value {
                    handler(json: JSON, error: nil)
                } else {
                    handler(json: nil, error: NSError(domain:"Error", code: 0, userInfo: nil))
                }
            }
            
        } else if method == "PUT" {
            
            Alamofire.request(.PUT, url, parameters: parameters, encoding: .JSON, headers: headers) .responseJSON { response in
                
                if let JSON = response.result.value {
                    handler(json: JSON, error: nil)
                } else {
                    handler(json: nil, error: NSError(domain:"Error", code: 0, userInfo: nil))
                }
                
            }
        } else if method == "DELETE" {
            
            Alamofire.request(.DELETE, url, parameters: parameters, encoding: .JSON, headers: headers) .responseJSON { response in
                
                if let JSON = response.result.value {
                    handler(json: JSON, error: nil)
                } else {
                    handler(json: nil, error: NSError(domain:"Error", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    //MARK: - Get Product by id
    
    func getProductDetailByID(prodID:Int , completionHandler: ProductsCompletionHandler) {
        
        let urlStr : NSString = baseUrl+"/products/"+String(prodID)+".json"
        let escapedAddress = urlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let urlpath: NSString = escapedAddress!
        
        callWebServiceForURL(urlpath as String, parameters: nil, headers: nil, method: "GET") { (json, error) -> Void in
            
            if error == nil {
                if (json!.objectForKey("error") == nil) {
                    let product = Product.init(json: json! .objectForKey("product")! as! [String : AnyObject])
                    completionHandler(product: product, error: nil)
                }
                else{
                    //return error
                    let err_info = ["NSLocalizedDescriptionKey":"No product found"]
                    let err : NSError = NSError(domain: "", code: 404, userInfo: err_info)
                    completionHandler(product: nil, error: err)
                }

            } else {
                //return error
                completionHandler(product: nil, error: error)
            }
        }
    }
    
    //MARK: - Get Product list by category

    func getProductList(category:String, pageCount:Int, completionHandler: ProductListCompletionHandler) {
        var urlStr : NSString = ""
        if(category == "All")
        {
            urlStr = baseUrl+"/products.json"
        }
        
        if(pageCount != 0) {
            urlStr = baseUrl+SDConstants.Webservice.SDGetProductbyCat+category+"&page="+String(pageCount)
        }
        else
        {
            urlStr = baseUrl+SDConstants.Webservice.SDGetProductbyCat+category
        }
        
        let escapedAddress = urlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let urlpath: NSString = escapedAddress!
        
        callWebServiceForURL(urlpath as String, parameters: nil, headers: nil, method: "GET") { (json, error) -> Void in
            
            if error == nil {
                
                if (json!.objectForKey("error") == nil) {
                    if json! .objectForKey("products")!.count == 0 && pageCount == 1  {
                        //alert no products found
                        
                    }
                    var productsListArray:NSMutableArray = []
                    json! .objectForKey("products")!.enumerateObjectsUsingBlock({ obj, index, stop in
                        let product = Product.init(json: obj as! [String : AnyObject])
                        productsListArray .addObject(product)
                    })
                    completionHandler(productArr: productsListArray, error: nil)
                }
                else {
                    //return error
                    let err_info = ["NSLocalizedDescriptionKey":"No product found"]
                    let err : NSError = NSError(domain: "", code: 404, userInfo: err_info)
                    completionHandler(productArr: nil, error: err)
                }
                
            } else {
                completionHandler(productArr: nil, error: error)
            }
        }
    }
    
    //MARK: - Download Image
    func getImageDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
}
