//
//  CommentTableViewCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/27/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

let commentPerLevel = 20

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var contentTextView: UITextView!
    @IBOutlet weak private var headerLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak private var contentLeadingMarigin: NSLayoutConstraint!
    
    func configure(with viewModel: CommentItemViewModel) {
        self.headerLabel.text = viewModel.getCommentHeaderText()
        self.contentTextView.attributedText = viewModel.getContent().htmlText(fontName: "Helvetica", fontSize: 13)
        
        let indentAmount = CGFloat(viewModel.getDisplayedLevel() * commentPerLevel)
        headerLeadingMargin.constant = indentAmount
        contentLeadingMarigin.constant = indentAmount
    }

}
