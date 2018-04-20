//
//  CommentTests.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 4/19/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import XCTest
@testable import Hacker_News_Zero


class CommentTests: XCTestCase {
    
    func testInit() {
        
        guard let commentData = DataHelper.jsonDataFromFile(named: "Comment"),
            let comment = Comment.decodeComment(from: commentData) else {
                XCTFail("Data is nil")
                return
        }
        
        XCTAssertEqual(comment.author, "aUser")
        XCTAssertEqual(comment.text, "Test comment text")
    }
    
    func testInitEmptyComment() {
        
        let emptyComment = Comment.createEmptyComment()
        
        XCTAssertNil(emptyComment.author)
        XCTAssertNil(emptyComment.text)
    }
    
}
