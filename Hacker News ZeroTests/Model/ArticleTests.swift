//
//  ArticleTests.swift
//  Hacker News ZeroTests/Users/matt/dev/personal/HNZ-v2/Hacker News Zero/Hacker News ZeroTests/Supporting Files/Test JSON/Article-Story.json
//
//  Created by Matt Stanford on 4/17/18.
//  Copyright © 2018 locacha. All rights reserved.
//

@testable import Hacker_News_Zero
import XCTest

class ArticleTests: XCTestCase {

    func testInit() {

        guard let articleData = DataHelper.jsonDataFromFile(named: "Article-Story"),
            let article = try? Article.decodeArticleFrom(jsonData: articleData) else {
            XCTFail("Data is nil")
            return
        }

        XCTAssertEqual(article.title, "Vim Clutch – hardware pedal for improved text editing speed")
        XCTAssertEqual(article.score, 113)
        XCTAssertEqual(article.articleType, "story")
        XCTAssertEqual(article.url, "https://github.com/alevchuk/vim-clutch")
        XCTAssertEqual(article.domain, "github.com")
    }

}
