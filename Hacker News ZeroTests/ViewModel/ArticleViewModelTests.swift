//
//  ArticleViewModelTests.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 4/19/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import XCTest
@testable import Hacker_News_Zero

class ArticleViewModelTests: XCTestCase {
    
    var viewModel: ArticleViewModel?
    var mockDate = MockDate()
    
    override func setUp() {
        super.setUp()
        
        guard let articleData = DataHelper.jsonDataFromFile(named: "Article-Story"),
            let article = try? Article.decodeArticleFrom(jsonData: articleData) else {
                XCTFail("Data is nil")
                return
        }
        
        viewModel = ArticleViewModel(article: article, dateGenerator: mockDate.getTestDate)
    }
    
    func testIconUrl() {
        
        guard let viewModel = viewModel else {
            XCTFail("Data is nil")
            return
        }
        
        XCTAssertEqual(viewModel.iconUrl?.absoluteString, "https://www.google.com/s2/favicons?domain=github.com")
    }
    
    func testDateString() {
    
        mockDate.currentDate = Date(timeIntervalSince1970: 1520780268)
        XCTAssertEqual(viewModel?.timeString, "1 second")
        
        mockDate.currentDate = Date(timeIntervalSince1970: 1520780270)
        XCTAssertEqual(viewModel?.timeString, "3 seconds")
        
        mockDate.currentDate = Date(timeIntervalSince1970: 1520780328)
        XCTAssertEqual(viewModel?.timeString, "1 minute")
        
        mockDate.currentDate = Date(timeIntervalSince1970: 1520780508)
        XCTAssertEqual(viewModel?.timeString,"4 minutes")
        
        mockDate.currentDate = Date(timeIntervalSince1970: 1520783868)
        XCTAssertEqual(viewModel?.timeString, "1 hour")
        
        mockDate.currentDate = Date(timeIntervalSince1970: 1520798268)
        XCTAssertEqual(viewModel?.timeString,"5 hours")
        
        mockDate.currentDate = Date(timeIntervalSince1970: 1520866668)
        XCTAssertEqual(viewModel?.timeString, "1 day")
        
        mockDate.currentDate = Date(timeIntervalSince1970: 1521298668)
        XCTAssertEqual(viewModel?.timeString, "6 days")
    }
    
    func testDetailString() {
        guard let viewModel = viewModel else {
            XCTFail("Data is nil")
            return
        }
        mockDate.currentDate = Date(timeIntervalSince1970: 1521298668)
        XCTAssertEqual(viewModel.detailLabelText, "113 points • 6 days")
    }
}
