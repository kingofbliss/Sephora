//
//  SephoraUITests.swift
//  SephoraUITests
//
//  Created by payoda on 27/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import XCTest

class SephoraUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNavigationToProductList() {
        let app = XCUIApplication()
        app.tables.cells.staticTexts["Makeup"].tap()
        // assert that modal view controller is presented
        XCTAssert(app.navigationBars["Makeup"].exists)
    }
    
    func testReturningToHomeScreenWhenError() {
        let app = XCUIApplication()
        app.tables.cells.staticTexts["Hair"].tap()
        app.alerts["Oops"].collectionViews.buttons["Ok"].tap()
        // assert that modal view controller is presented
        XCTAssert(app.navigationBars["Sephora"].exists)
    }

    func testReturningToScanScreenWhenError() {
        // Works only on device
        //Please scan a qr code
        let app = XCUIApplication()
        app.tabBars.buttons["Scan"].tap()
        app.alerts["Oops"].collectionViews.buttons["Ok"].tap()
        // assert that modal view controller is presented
        XCTAssert(app.navigationBars["Scan"].exists)
    }
    
}
