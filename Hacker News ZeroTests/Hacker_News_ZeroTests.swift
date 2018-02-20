//
//  Hacker_News_ZeroTests.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 1/21/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import XCTest
@testable import Hacker_News_Zero

class Hacker_News_ZeroTests: XCTestCase {
    
    var articleVC : ArticleViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.articleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.articleVC = nil
        super.tearDown()
    }
    
    func testUIState()
    {
        let viewModel = self.articleVC.viewModel
            
        
        assert(viewModel != nil)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
