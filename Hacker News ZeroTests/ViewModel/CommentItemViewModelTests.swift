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
        
        viewModel = CommentItemViewModel(with: tempComment, level: 0, dateGenerator: mockDate.getTestDate)
    }
    
    func testHeaderText() {
        mockDate.currentDate = Date(timeIntervalSince1970: 1522873162)
        let headerText = viewModel?.commentHeaderText
        XCTAssertEqual(headerText?.string, "aUser • 3 seconds")
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
        
        let topLevelViewModel = CommentItemViewModel(with: comment, level: 0)
        XCTAssertEqual(topLevelViewModel.displayedLevel, 0)
        
        let nestedViewModel = CommentItemViewModel(with: comment, level: 10)
        XCTAssertEqual(nestedViewModel.displayedLevel, 6)

    }
}
