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
        let testRepository = HackerNewsRepository(client: MockApiClient(),
                                                  cache: ApiCache(),
                                                  settingsCache: SettingsCache())
        let viewModel = ArticleListViewModel(repository: testRepository)
        viewController?.viewModel = viewModel
        _ = viewController?.loadViewIfNeeded()

    }

    func testTableData() {
        guard let tableView = viewController?.tableView else {
            XCTFail("Couldn't find VC TableView!")
            return
        }
        XCTAssertEqual(viewController?.tableView(tableView, numberOfRowsInSection: 0), 3)
        XCTAssertEqual(viewController?.numberOfSections(in: tableView), 1)

        let firstCellIndexPath = IndexPath(row: 0, section: 0)
        guard let firstCell = viewController?.tableView(tableView, cellForRowAt: firstCellIndexPath) as? ArticleTableViewCell else {
            XCTFail("Couldn't get first article cell!")
            return
        }

        XCTAssertEqual(firstCell.titleLabel.text, "What makes BeOS and Haiku unique")
    }
}
