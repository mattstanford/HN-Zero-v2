//
//  ArticleListTests.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 11/27/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import XCTest

@testable import Hacker_News_Zero

class ArticleListTests: XCTestCase {

    var viewController: ArticleViewController?

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "ArticleViewController") as? ArticleViewController

    }

    func testTest() {
        print("hi")
    }
}
