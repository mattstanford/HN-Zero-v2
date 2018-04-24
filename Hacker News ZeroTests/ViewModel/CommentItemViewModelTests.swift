//
//  CommentViewModelTests.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 4/23/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import XCTest
@testable import Hacker_News_Zero

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
        viewModel = CommentItemViewModel(with: tempComment, level: 0)
    }
    
    func testHeaderText() {
        let headerText = viewModel?.getCommentHeaderText()
        XCTAssertEqual(headerText, "aUser")
    }
    
    func testContent() {
        let content = viewModel?.getContent()
        XCTAssertEqual(content, "Test comment text")
    }
    
    func testDisplayedLevel() {
        guard let comment = comment else {
            XCTFail("data is nil!")
            return
        }
        
        let topLevelViewModel = CommentItemViewModel(with: comment, level: 0)
        XCTAssertEqual(topLevelViewModel.getDisplayedLevel(), 0)
        
        let nestedViewModel = CommentItemViewModel(with: comment, level: 10)
        XCTAssertEqual(nestedViewModel.getDisplayedLevel(), 6)

    }
}
