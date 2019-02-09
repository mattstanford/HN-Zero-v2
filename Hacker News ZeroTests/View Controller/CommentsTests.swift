//
//  CommentsTests.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 12/7/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import XCTest

@testable import Hacker_News_Zero

class CommentsTests: XCTestCase {

    var viewController: CommentsViewController?

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as? CommentsViewController
        let testRepository = HackerNewsRepository(client: MockApiClient(),
                                                  cache: ApiCache(),
                                                  settingsCache: SettingsCache())
        let viewModel = CommentsViewModel(with: testRepository, colorScheme: ColorScheme.standard)
        viewController?.viewModel = viewModel
        _ = viewController?.loadViewIfNeeded()

    }

    func testLoadData() {
        guard let tableView = viewController?.tableView else {
            XCTFail("Couldn't find VC TableView!")
            return
        }
        tableView.reloadData()
        XCTAssertEqual(viewController?.tableView(tableView, numberOfRowsInSection: 0), 1)
        XCTAssertEqual(viewController?.numberOfSections(in: tableView), 1)

        let firstCellIndexPath = IndexPath(row: 0, section: 0)
        guard let loadingCell = viewController?.tableView(tableView, cellForRowAt: firstCellIndexPath) as? LoadingSpinnerCell else {
            XCTFail("Couldn't get first cell!")
            return
        }

        tableView.reloadData()
        XCTAssertEqual(viewController?.tableView(tableView, numberOfRowsInSection: 0), 1)
//        XCTAssertEqual(firstCell.headerLabel.text, "What makes BeOS and Haiku unique")
//        XCTAssertEqual(firstCell.contentLabel.attributedText?.string, "hi there")
    }

}
