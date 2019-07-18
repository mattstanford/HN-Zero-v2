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
    let testRepository = RepositoryHelper.getTestRepository()

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as? CommentsViewController
        viewController.repository = testRepository
    }

    func testLoadData() {
        guard let article = ModelHelper.getArticle(from: "Article-Story") else {
            XCTFail("Couldn't find VC TableView!")
            return
        }
        viewController.viewModel.article = article
        viewController.viewModel.clearData()
        _ = viewController?.loadViewIfNeeded()

        guard let tableView = viewController.tableView else {
            XCTFail("Couldn't find VC TableView!")
            return
        }

        viewController.tableView.reloadData()

        XCTAssertEqual(viewController.tableView(tableView, numberOfRowsInSection: 0), 1)
        XCTAssertEqual(viewController.numberOfSections(in: tableView), 2)

        let headerIndexPath = IndexPath(row: 0, section: 0)
        let loadingCellIndexPath = IndexPath(row: 0, section: 1)
        guard let headerCell = viewController.tableView(tableView, cellForRowAt: headerIndexPath) as? CommentHeaderTableViewCell else {
            XCTFail("Couldn't get cells!")
            return
        }

        XCTAssertEqual(viewController.tableView(tableView, numberOfRowsInSection: 0), 1)
        XCTAssertEqual(viewController.tableView(tableView, numberOfRowsInSection: 1), 1)
        XCTAssert(viewController.tableView(tableView, cellForRowAt: loadingCellIndexPath) is LoadingSpinnerCell)

        XCTAssertEqual(headerCell.titleLabel.text, "Vim Clutch – hardware pedal for improved text editing speed")
        XCTAssertNil(headerCell.postTextView.attributedText)
        XCTAssertEqual(headerCell.infoLabel.text, "3 comments • mfrw")

        //Comments get loaded in
        _ = try? viewController.viewModel.updateCommentData().toBlocking().first()
        viewController.tableView.reloadData()
        XCTAssertEqual(viewController.numberOfSections(in: tableView), 2)
        XCTAssertEqual(viewController.tableView(tableView, numberOfRowsInSection: 0), 1)
        XCTAssertEqual(viewController.tableView(tableView, numberOfRowsInSection: 1), 3)

        let commentCellPath = IndexPath(row: 0, section: 1)
        guard let commentCell = viewController.tableView(tableView, cellForRowAt: commentCellPath) as? CommentTableViewCell else {
            XCTFail("Error getting comment cell!")
            return
        }
        XCTAssertEqual(commentCell.contentLabel.attributedText?.string, "This is a comment with no replies.")
    }

}
