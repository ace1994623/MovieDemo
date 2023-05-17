//
//  MovieDemoUITests.swift
//  MovieDemoUITests
//
//  Created by Li, Jiawen on 2023/4/29.
//

import XCTest
@testable import MovieDemo

final class MovieDemoUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_empty_keyword() {
        // Set key word only contains space
        let keyword = "    "
        // Get search bar
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText(keyword)
        app.buttons["Search"].tap()

        // Wait for result
        sleep(3)
        let tableView = app.tables.firstMatch
        // Test not allow to search word
        XCTAssertTrue(tableView.cells.count == 0,
                      "Should have no result when searching word only contails space")
    }
    
    func test_main_work_flow() throws {
        // Test search functionality
        let keyword = "test"
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText(keyword)
        app.buttons["Search"].tap()
        var tableView = app.tables.firstMatch
        // Wait for result
        sleep(3)
        // test result
        XCTAssertTrue(tableView.cells.count > 0, "Search result should not be empty")
        
        // Test jump to movie detail page
        var cell = tableView.cells.firstMatch
        sleep(1)
        cell.tap()
        sleep(1)
        if(app.staticTexts["Remove favorite"].exists) {
            // For testing, remove from favorite list if current movie is allreday in
            app.navigationBars.buttons.element(boundBy: 1).tap()
            sleep(1)
        }
        XCTAssertTrue(app.staticTexts["Add favorite"].exists,
                      "Should navigate to movie detail page")
        
        // Test Add to favorite list
        app.navigationBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        XCTAssertTrue(app.staticTexts["Remove favorite"].exists,
                      "Shold change button text after add to favorite list")
        
        // Test Remove to favorite list
        app.navigationBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        XCTAssertTrue(app.staticTexts["Add favorite"].exists,
                      "Shold change button text after remove from favorite list")
        
        // Add back to test favorite list view later
        app.navigationBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        XCTAssertTrue(app.staticTexts["Remove favorite"].exists,
                      "Shold change button text after add to favorite list")
        
        // Test back to main view
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        
        // Test jump to favorite list view
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        
        // Favorite list view should have tableview
        tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.cells.count > 0,
                      "Favorite list should not be empty")
        let cellsCount = tableView.cells.count
        
        // Test jump to detail view from favorite list view
        cell = tableView.cells.firstMatch
        sleep(1)
        cell.tap()
        sleep(1)
        // Remove one from the favorite list
        app.navigationBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        // Back to favorite list view and check the cells count
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.cells.count == cellsCount - 1,
                      "Favorite list size should minus 1 after remove one movive from favorite list")
        
        
        // Test back to main view
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
    }
}
