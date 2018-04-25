//
//  CommentTableViewCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/27/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit
import Atributika

let commentPerLevel = 20

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var contentLabel: AttributedLabel!
    @IBOutlet weak private var headerLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak private var contentLeadingMarigin: NSLayoutConstraint!
    
    func configure(with viewModel: CommentItemViewModel, linkHandler: @escaping (URL) -> Void) {
        headerLabel.attributedText = viewModel.commentHeaderText
        
        if let text = viewModel.comment.text {
            contentLabel.setHtmlText(text: text, linkHandler: linkHandler)
        }
        
        let indentAmount = CGFloat(viewModel.displayedLevel * commentPerLevel)
        headerLeadingMargin.constant = indentAmount
        contentLeadingMarigin.constant = indentAmount
    }

}
