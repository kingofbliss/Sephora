//
//  ProductDetailViewController.swift
//  Sephora
//
//  Created by payoda on 27/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController{
    
    var productID:Int? = 0
    var product:Product?
    
    @IBOutlet weak var onSaleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageVw: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Info"
        // Do any additional setup after loading the view.
        getProductDetailByID(productID!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickAddCartBtn(sender: UIButton?) {
        if !(CartViewController().addProductToCart(self.product!))
        {
            //Show error alert
            SDUtils().showAlert(self, message:"Product already in cart")
        }
        SDUtils().changeTabBadge(self)
    }
    
    func initializeData() {
        descriptionLabel.text = product?.productDescription
        titleLabel.text = product?.productName
        rateLabel.text = "S$"+(product!.productPrice?.stringValue)!
        imageVw.contentMode = .ScaleAspectFit
        onSaleLabel.hidden = true
        if product?.productOnSale == true {
            onSaleLabel.hidden = false
        }
        
        if product!.productImageData?.length > 0 {
            imageVw.image = UIImage(data: product!.productImageData!)
        } else {
            let url = NSURL(string:product!.productImgUrl!)
            let serviceLayer = SDWebServiceLayer()
            serviceLayer.getImageDataFromUrl(url!) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    self.product!.productImageData = data
                    self.imageVw.image = UIImage(data: data)
                }
            }
        }
    }
    
    //MARK: - Service Call
    /**
     API Service Call to get product list based on category
     
     - parameter category: Selected Category
     */
    
    func getProductDetailByID(prodID:Int){
        let serviceLayer = SDWebServiceLayer()
        serviceLayer.getProductDetailByID(productID!) { (product, error) -> Void in
            if error == nil{
                self.product = product
                self.initializeData()
            }
            else
            {
                //alert no product found
                SDUtils().showAlertandDismiss(self,message:SDConstants.ErrorMessages.ItemNotFound)
            }
        }
    }
    
    //MARK: - Preview Action
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let addToCart = UIPreviewAction(title: "Add to cart", style: .Default) { (action, viewController) -> Void in
           print("Add to cart")
        }
        return [addToCart]
    }
    
}
