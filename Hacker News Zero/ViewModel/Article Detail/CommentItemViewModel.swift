//
//  CommentItemViewModel.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/10/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Atributika
import Foundation

class CommentItemViewModel {

    let maxLevel = 6

    let comment: Comment
    let isOp: Bool
    private let level: Int
    private let dateGenerator: () -> Date
    var repository: HackerNewsRepository

    init(with comment: Comment, isOp: Bool, level: Int, repository: HackerNewsRepository, dateGenerator: @escaping () -> Date = Date.init) {
        self.comment = comment
        self.isOp = isOp
        self.level = level
        self.dateGenerator = dateGenerator
        self.repository = repository
    }

    var commentHeaderText: NSAttributedString {
        let colorScheme = repository.settingsCache.colorScheme

        let numIndentDots = max(self.level - maxLevel, 0)
        var headerText = ""

        let authorTag = Style("author").font(Font.boldSystemFont(ofSize: AppConstants.defaultFontSize)).foregroundColor(colorScheme.contentTextColor)

        headerText += "<author>"

        for _ in 0..<numIndentDots {
            headerText +=  "• "
        }

        headerText += self.comment.author ?? ""
        headerText += "</author>"

        //Set the "(OP)" text if necessary
        let opTextTag = Style("OP").font(Font.boldSystemFont(ofSize: AppConstants.defaultFontSize)).foregroundColor(colorScheme.accentColor)
        if isOp {
            headerText += "<OP> (OP)</OP>"
        }

        // Time text is lighter in color
        let grayTextTag = Style("grayFont").font(Font.systemFont(ofSize: AppConstants.defaultFontSize)).foregroundColor(colorScheme.contentInfoTextColor)

        headerText += "<grayFont> • " + timeString + "</grayFont>"

        return headerText.style(tags: authorTag, grayTextTag, opTextTag).attributedString
    }

    var content: String {

        if comment.isDeleted {
            return "[Deleted]"
        } else {
            return comment.text ?? ""
        }
    }

    var displayedLevel: Int {
        return min(self.level, maxLevel)
    }

    private var timeString: String {
        let now = dateGenerator()
        let timePosted = comment.time

        return now.getStringofTimePassedSinceDate(referenceDate: timePosted)
    }
}
