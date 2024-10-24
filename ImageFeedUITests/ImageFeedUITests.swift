//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Ilya Nikitash on 24.10.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments = ["test mode"]
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        
        loginTextField.tap()
        loginTextField.typeText("")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
            
        passwordTextField.tap()
        passwordTextField.typeText("")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
            
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.descendants(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(10)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like button off"].tap()
        cellToLike.buttons["like button on"].tap()
        
        sleep(10)
        
        cellToLike.tap()
        
        sleep(10)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
           
        let navBackButtonWhiteButton = app.buttons["navigation back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(10)
        app.tabBars.buttons.element(boundBy: 1).tap()
           
        XCTAssertTrue(app.staticTexts[""].exists)
        XCTAssertTrue(app.staticTexts[""].exists)
            
        app.buttons["logout button"].tap()
            
        app.alerts["Выход"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
