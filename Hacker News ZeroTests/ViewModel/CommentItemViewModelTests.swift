//
//  CommentViewModelTests.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 4/23/18.
//  Copyright © 2018 locacha. All rights reserved.
//

@testable import Hacker_News_Zero
import XCTest

class CommentItemViewModelTests: XCTestCase {

    var viewModel: CommentItemViewModel?
    var comment: Comment?
    var mockDate = MockDate()

    override func setUp() {
        super.setUp()

        guard let data = DataHelper.jsonDataFromFile(named: "Comment"),
            let tempComment = Comment.decodeComment(from: data) else {
                XCTFail("Data is nil")
                return
        }
        comment = tempComment

        viewModel = CommentItemViewModel(with: tempComment, isOp: false, level: 0, colorScheme: .standard, dateGenerator: mockDate.getTestDate)
    }

    func testHeaderText() {
        guard let comment = comment else {
            XCTFail("data is nil!")
            return
        }

        mockDate.currentDate = Date(timeIntervalSince1970: 1522873162)
        let headerText = viewModel?.commentHeaderText
        XCTAssertEqual(headerText?.string, "aUser • 3 seconds")

        let opViewModel = CommentItemViewModel(with: comment, isOp: true, level: 0, colorScheme: .standard, dateGenerator: mockDate.getTestDate)
        XCTAssertEqual(opViewModel.commentHeaderText.string, "aUser (OP) • 3 seconds")
    }

    func testContent() {
        let content = viewModel?.content
        XCTAssertEqual(content, "Test comment text")
    }

    func testDisplayedLevel() {
        guard let comment = comment else {
            XCTFail("data is nil!")
            return
        }

        let topLevelViewModel = CommentItemViewModel(with: comment, isOp: false, level: 0, colorScheme: .standard)
        XCTAssertEqual(topLevelViewModel.displayedLevel, 0)

        let nestedViewModel = CommentItemViewModel(with: comment, isOp: false, level: 10, colorScheme: .standard)
        XCTAssertEqual(nestedViewModel.displayedLevel, 6)

    }
}
