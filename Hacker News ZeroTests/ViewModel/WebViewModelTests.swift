//
//  WebViewModelTests.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 5/2/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

import XCTest
@testable import Hacker_News_Zero

class WebViewModelTests: XCTestCase {
    
    let viewModel = WebViewModel()
    
    func testCurrentUrl() {
        
        viewModel.needsReset = false
        
        viewModel.currentUrl = URL(string: "http://www.google.com")
        XCTAssertEqual(viewModel.needsReset, true)
    }
    
    func testNewArticle() {
        
        guard let articleData = DataHelper.jsonDataFromFile(named: "Article-Story"),
            let article = try? Article.decodeArticleFrom(jsonData: articleData) else {
                XCTFail("Data is nil")
                return
        }
        
        viewModel.needsReset = false
        viewModel.article = article
        
        XCTAssertEqual(viewModel.needsReset, true)
        
        viewModel.needsReset = false
        viewModel.article = article
        XCTAssertEqual(viewModel.needsReset, false)
    }

}
