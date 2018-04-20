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
    
    override func setUp() {
        super.setUp()
        
        guard let articleData = DataHelper.jsonDataFromFile(named: "Article-Story"),
            let article = try? Article.decodeArticleFrom(jsonData: articleData) else {
                XCTFail("Data is nil")
                return
        }
        
        viewModel = ArticleViewModel(article: article)
    }
    
    func testDomain() {
        
        guard let viewModel = viewModel else {
            XCTFail("Data is nil")
            return
        }
        
        XCTAssertEqual(viewModel.domain, "github.com")
    }
    
    func testIconUrl() {
        
        guard let viewModel = viewModel else {
            XCTFail("Data is nil")
            return
        }
        
        XCTAssertEqual(viewModel.iconUrl?.absoluteString, "https://www.google.com/s2/favicons?domain=github.com")
    }
    
    func testDateString() {
        
        guard let viewModel = viewModel else {
            XCTFail("Data is nil")
            return
        }
        
        let referenceDateSecond = Date(timeIntervalSince1970: 1520780268)
        XCTAssertEqual(viewModel.getTimeString(referenceDate: referenceDateSecond), "1 second")
        
        let referenceDateSeconds = Date(timeIntervalSince1970: 1520780270)
        XCTAssertEqual(viewModel.getTimeString(referenceDate: referenceDateSeconds), "3 seconds")
        
        let referenceDateMinute = Date(timeIntervalSince1970: 1520780328)
        XCTAssertEqual(viewModel.getTimeString(referenceDate: referenceDateMinute), "1 minute")
        
        let referenceDateMinutes = Date(timeIntervalSince1970: 1520780508)
        XCTAssertEqual(viewModel.getTimeString(referenceDate: referenceDateMinutes), "4 minutes")
        
        let referenceDateHour = Date(timeIntervalSince1970: 1520783868)
        XCTAssertEqual(viewModel.getTimeString(referenceDate: referenceDateHour), "1 hour")
        
        let referenceDateHours = Date(timeIntervalSince1970: 1520798268)
        XCTAssertEqual(viewModel.getTimeString(referenceDate: referenceDateHours), "5 hours")
        
        let referenceDateDay = Date(timeIntervalSince1970: 1520866668)
        XCTAssertEqual(viewModel.getTimeString(referenceDate: referenceDateDay), "1 day")
        
        let referenceDateDays = Date(timeIntervalSince1970: 1521298668)
        XCTAssertEqual(viewModel.getTimeString(referenceDate: referenceDateDays), "6 days")
        
        
        
        
        
        
        
    }
}
