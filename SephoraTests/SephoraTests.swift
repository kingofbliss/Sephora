//
//  SephoraTests.swift
//  SephoraTests
//
//  Created by payoda on 27/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import XCTest
@testable import Sephora

class SephoraTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProductList() {
        let expectation = expectationWithDescription("Product Id not nil")
        let serviceLayer = SDWebServiceLayer()
        serviceLayer.getProductList("All",pageCount: 0) { (products, error) -> Void in
            XCTAssert(products?.count>0)
            products!.enumerateObjectsUsingBlock({ obj, index, stop in
                let product : Product = obj as! Product
                XCTAssertNotNil(product.productId, "Product Id Should be not nil")
            })
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { error in
            // ...
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testProduct() {
        let expectation = expectationWithDescription("Product not nil")
        let serviceLayer = SDWebServiceLayer()
        serviceLayer.getProductDetailByID(10) { (product, error) -> Void in
            XCTAssertNotNil(product)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { error in
            // ...
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testCorrectProductReturn() {
        let expectation = expectationWithDescription("Product return was same as requested")
        let serviceLayer = SDWebServiceLayer()
        serviceLayer.getProductDetailByID(10) { (product, error) -> Void in
            XCTAssertEqual(product?.productId, 10)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { error in
            // ...
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testCorrectCategoryReturn() {
        let expectation = expectationWithDescription("Product list return was of same category as requested")
        let serviceLayer = SDWebServiceLayer()
        serviceLayer.getProductList("Makeup",pageCount: 0) { (products, error) -> Void in
            XCTAssert(products?.count>0)
            products!.enumerateObjectsUsingBlock({ obj, index, stop in
                let product : Product = obj as! Product
                XCTAssertEqual(product.productCategory, "Makeup")
            })
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { error in
            // ...
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }

    }
}
