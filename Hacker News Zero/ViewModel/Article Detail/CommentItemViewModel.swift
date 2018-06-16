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
    let isOp: Bool
    let colorScheme: ColorScheme
    private let level: Int
    private let dateGenerator: () -> Date
    
    
    init(with comment: Comment, isOp: Bool, level: Int, colorScheme: ColorScheme, dateGenerator: @escaping () -> Date = Date.init) {
        self.comment = comment
        self.isOp = isOp
        self.level = level
        self.dateGenerator = dateGenerator
        self.colorScheme = colorScheme
    }
    
    var commentHeaderText: NSAttributedString {
        
        
        let numIndentDots = max(self.level - maxLevel, 0)
        var headerText = ""
        
        for _ in 0..<numIndentDots {
            headerText +=  "• "
        }
        
        headerText += self.comment.author ?? ""
        
        //Set the "(OP)" text if necessary
        let opTextTag = Style("OP").font(Font.boldSystemFont(ofSize: AppConstants.defaultFontSize)).foregroundColor(UIColor.blue)
        if isOp {
            headerText += "<OP> (OP)</OP>"
        }
        
        // Time text is lighter in color
        let grayTextTag = Style("grayFont").font(Font.systemFont(ofSize: AppConstants.defaultFontSize)).foregroundColor(UIColor.lightGray)
        
        headerText += "<grayFont> • " + timeString + "</grayFont>"
        
        return headerText.style(tags: grayTextTag, opTextTag).attributedString
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
