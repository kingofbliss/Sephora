//
//  ProductListViewController.swift
//  Sephora
//
//  Created by payoda on 27/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController,UIViewControllerPreviewingDelegate{
    
    var categoryTitle:String? = ""
    var productsListArray:NSMutableArray = []
    var pageCount:Int = 1
    var stopPagination:Bool = false

    @IBOutlet weak var collectionVw: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        getProductList(categoryTitle!)
        self.title = categoryTitle
        
        //Setup 3D touch
        if( traitCollection.forceTouchCapability == .Available){
            
            registerForPreviewingWithDelegate(self, sourceView: self.collectionVw)
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        SDUtils().changeTabBadge(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: - UIcollectionview Datasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsListArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("customCell", forIndexPath: indexPath) as! ProductListCollectionViewCell
    
        let product = productsListArray[indexPath.row] as! Product

        cell.imageVw.image = nil
        
        cell.layer.borderWidth = 1.0;
        cell.layer.borderColor=UIColor.blackColor().CGColor;
        
        if product.productImageData?.length > 0 {
            cell.imageVw.image = UIImage(data: product.productImageData!)
        } else {
            let url = NSURL(string:product.productImgUrl!)
            let serviceLayer = SDWebServiceLayer()
            serviceLayer.getImageDataFromUrl(url!) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    print(response?.suggestedFilename ?? "")
                    product.productImageData = data
                    cell.imageVw.image = UIImage(data: data)
                }
            }
        }
        
        cell.onSaleLabel.hidden = true
        if product.productOnSale == true {
            cell.onSaleLabel.hidden = false
        }
        
        cell.imageVw.contentMode = .ScaleAspectFit
        cell.titleLabel.text = product.productName
        cell.rateLabel.text = "S$"+(product.productPrice?.stringValue)!
        
        //Two lines needed if we use contraints
        cell.contentView.frame = cell.bounds
        cell.contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        if indexPath.row == pageCount*10-1 && stopPagination == false {
            pageCount += 1
            getProductList(categoryTitle!)
        }
        
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake(collectionView.frame.size.width/2-5, collectionView.frame.size.width/2-5)
    }
    
    //MARK: - UIcollectionview Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let product = productsListArray[indexPath.row] as! Product
        loadProductDetailVC(product)
    }
    
    /**
     Load product detail VC based on category
     
     - parameter categoryTitle: Selected Category
     */
    
    func loadProductDetailVC(productObj:Product) {
        let productDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("productDetailViewController") as! ProductDetailViewController
        productDetailVC.productID = productObj.productId
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }

    //MARK: - Service Call
    /**
     API Service Call to get product list based on category
     
     - parameter category: Selected Category
     */
    
    func getProductList(category:String){
        let serviceLayer = SDWebServiceLayer()
        serviceLayer.getProductList(category,pageCount: self.pageCount){ (productArr, error) -> Void in
            if error == nil{
                if productArr!.count < 10  {
                    self.stopPagination = true
                }
                if productArr!.count == 0 && self.pageCount == 1  {
                    //alert no products found
                    SDUtils().showAlertandDismiss(self,message:SDConstants.ErrorMessages.NoItemsInCategory)
                }
                productArr!.enumerateObjectsUsingBlock({ obj, index, stop in
                    self.productsListArray .addObject(obj)
                })
                self.collectionVw.reloadData()
            }
            else
            {
                SDUtils().showAlertandDismiss(self,message:(error?.localizedDescription)!)
            }
        }
    }
    
    
    //MARK: - 3D touch delegate
   
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.collectionVw?.indexPathForItemAtPoint(location) else { return nil }
        guard let cell = self.collectionVw?.cellForItemAtIndexPath(indexPath) else { return nil }
        let product = productsListArray[indexPath.row] as! Product
        guard let productDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("productDetailViewController") as? ProductDetailViewController else { return nil }
        productDetailVC.productID = product.productId
        productDetailVC.preferredContentSize = CGSize(width: 0.0, height: 450)
        previewingContext.sourceRect = cell.frame
        return productDetailVC
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}

class ProductListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var onSaleLabel: UILabel!
    @IBOutlet weak var imageVw: UIImageView!

    
}