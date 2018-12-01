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

    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var contentLabel: AttributedLabel!
    @IBOutlet weak private var headerLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak private var contentLeadingMarigin: NSLayoutConstraint!

    func configure(with viewModel: CommentItemViewModel, linkHandler: @escaping (URL) -> Void) {
        headerLabel.attributedText = viewModel.commentHeaderText

        backgroundColor = viewModel.colorScheme.contentBackgroundColor
        contentView.backgroundColor = viewModel.colorScheme.contentBackgroundColor

        contentLabel.setHtmlText(text: viewModel.content, colorScheme: viewModel.colorScheme, linkHandler: linkHandler)
        contentLabel.backgroundColor = viewModel.colorScheme.contentBackgroundColor

        let indentAmount = CGFloat(viewModel.displayedLevel * commentPerLevel)
        headerLeadingMargin.constant = indentAmount
        contentLeadingMarigin.constant = indentAmount
    }

}
