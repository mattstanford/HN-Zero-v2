//
//  CommentItemViewModel.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/10/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import Atributika

class CommentItemViewModel {
    
    let maxLevel = 6
    
    let comment: Comment
    private let level: Int
    private let dateGenerator: () -> Date
    
    init(with comment: Comment, level: Int, dateGenerator: @escaping () -> Date = Date.init) {
        self.comment = comment
        self.level = level
        self.dateGenerator = dateGenerator
    }
    
    var commentHeaderText: NSAttributedString {
        
        let tagName = "grayFont"
        let grayTextTag = Style(tagName).font(Font.systemFont(ofSize: AppConstants.defaultFontSize)).foregroundColor(UIColor.lightGray)
        
        let numIndentDots = max(self.level - maxLevel, 0)
        var headerText = ""
        
        for _ in 0..<numIndentDots {
            headerText +=  "• "
        }
        
        headerText += self.comment.author ?? "<unknown>"
        headerText += "<" + tagName + "> • " + timeString + "</" + tagName + ">"
        
        return headerText.style(tags: grayTextTag).attributedString
    }
    
    var content: String {
        let content = self.comment.text ?? ""
        return content
    }
    
    var displayedLevel: Int {
        return min(self.level, maxLevel)
    }
    
    private var timeString: String
    {
        let now = dateGenerator()
        let timePosted = comment.time
        
        return now.getStringofTimePassedSinceDate(referenceDate: timePosted)
    }
}
