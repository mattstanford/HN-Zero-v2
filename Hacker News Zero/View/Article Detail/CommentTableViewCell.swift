//
//  CommentTableViewCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/27/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Atributika
import UIKit

let commentPerLevel = 20

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var contentLabel: AttributedLabel!
    @IBOutlet weak var separator: UIView!

    @IBOutlet weak var contentLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var separatorleadingMargin: NSLayoutConstraint!

    func configure(with viewModel: CommentItemViewModel, nextCommentLevel: Int, linkHandler: @escaping (URL) -> Void) {
        headerLabel.attributedText = viewModel.commentHeaderText

        backgroundColor = viewModel.colorScheme.contentBackgroundColor
        contentView.backgroundColor = viewModel.colorScheme.contentBackgroundColor

        contentLabel.setHtmlText(text: viewModel.content, colorScheme: viewModel.colorScheme, linkHandler: linkHandler)
        contentLabel.backgroundColor = viewModel.colorScheme.contentBackgroundColor
        contentLeadingMargin.constant = getIndentAmount(for: viewModel.displayedLevel)

        let separatorIndent: CGFloat
        if nextCommentLevel < viewModel.displayedLevel {
            separatorIndent = getIndentAmount(for: nextCommentLevel) - 4
        } else {
            separatorIndent = getIndentAmount(for: viewModel.displayedLevel) - 4
        }
        separatorleadingMargin.constant = separatorIndent

        separator.backgroundColor = viewModel.colorScheme.contentInfoTextColor

    }

    func getIndentAmount(for displayedLevel: Int) -> CGFloat {
        return CGFloat(displayedLevel * commentPerLevel) + 16
    }

}
