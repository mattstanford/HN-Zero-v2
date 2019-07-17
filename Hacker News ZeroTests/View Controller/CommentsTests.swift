//
//  CommentsTests.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 12/7/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import RxBlocking
import XCTest

@testable import Hacker_News_Zero

class CommentsTests: XCTestCase {

    var viewController: CommentsViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as? CommentsViewController
        let testRepository = RepositoryHelper.getTestRepository()
        viewController.repository = testRepository
        _ = viewController?.loadViewIfNeeded()

    }

    func testLoadData() {
        guard let tableView = viewController?.tableView else {
            XCTFail("Couldn't find VC TableView!")
            return
        }
        tableView.reloadData()
        XCTAssertEqual(viewController.tableView(tableView, numberOfRowsInSection: 0), 1)
        XCTAssertEqual(viewController.numberOfSections(in: tableView), 2)

        let headerIndexPath = IndexPath(row: 0, section: 0)
        let loadingCellIndexPath = IndexPath(row: 0, section: 1)
        guard let headerCell = viewController.tableView(tableView, cellForRowAt: headerIndexPath) as? CommentHeaderTableViewCell,
            let loadingCell = viewController.tableView(tableView, cellForRowAt: loadingCellIndexPath) as? LoadingSpinnerCell else {
            XCTFail("Couldn't get cells!")
            return
        }

        XCTAssertEqual(viewController.tableView(tableView, numberOfRowsInSection: 0), 1)
        XCTAssertEqual(viewController.tableView(tableView, numberOfRowsInSection: 1), 1)

        XCTAssertEqual(headerCell.postTextView.attributedText?.string, "hi there")

//        XCTAssertEqual(firstCell.headerLabel.text, "What makes BeOS and Haiku unique")
//        XCTAssertEqual(firstCell.contentLabel.attributedText?.string, "hi there")
    }

}
