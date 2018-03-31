//
//  CommentItemViewModel.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/10/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

class CommentItemViewModel {
    
    let maxLevel = 6
    
    let comment: Comment
    private let level: Int
    
    init(with comment: Comment, level: Int) {
        self.comment = comment
        self.level = level
    }
    
    func getCommentHeaderText() -> String {
        let numIndentDots = max(self.level - maxLevel, 0)
        
        var headerText = ""
        
        for _ in 0..<numIndentDots {
            headerText +=  "• "
        }
        
        headerText += self.comment.author ?? "<unknown>"
        
        return headerText
    }
    
    func getContent() -> String {
        let content = self.comment.text ?? ""
        return "ID: " + String(describing: self.comment.id) + content
    }
    
    func getDisplayedLevel() -> Int {
        return min(self.level, maxLevel)
    }
}
