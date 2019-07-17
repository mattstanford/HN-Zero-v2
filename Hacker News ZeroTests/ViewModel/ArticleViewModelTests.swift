//
//  ArticleViewModelTests.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 4/19/18.
//  Copyright © 2018 locacha. All rights reserved.
//

@testable import Hacker_News_Zero
import XCTest

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

    func testDetailString() {
        guard let viewModel = viewModel else {
            XCTFail("Data is nil")
            return
        }
        mockDate.currentDate = Date(timeIntervalSince1970: 1521298668)
        XCTAssertEqual(viewModel.detailLabelText, "113 points • 6 days • github.com")

        guard let jobStoryData = DataHelper.jsonDataFromFile(named: "Article-Job"),
            let article = try? Article.decodeArticleFrom(jsonData: jobStoryData) else {
                XCTFail("Data is nil")
                return
        }
        let jobViewModel = ArticleViewModel(article: article,
                                            dateGenerator: mockDate.getTestDate)
        XCTAssertEqual(jobViewModel.detailLabelText, "3591 days")
    }
}
