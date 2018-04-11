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
        headerLabel.text = viewModel.getCommentHeaderText()
        
        contentLabel.numberOfLines = 0
        
        if let font =  Font(name: AppConstants.defaultFont, size: AppConstants.defaultFontSize) {
            contentLabel.font = font
        }
        contentLabel.attributedText = viewModel.getContent().htmlText()
        
        
        contentLabel.onClick = { label, detection in
            switch detection.type {
            case .tag(let tag):
                self.handleLinkClicked(tag: tag, linkHandler: linkHandler)
            default:
                print("something else!")
            }
        }
        
        let indentAmount = CGFloat(viewModel.getDisplayedLevel() * commentPerLevel)
        headerLeadingMargin.constant = indentAmount
        contentLeadingMarigin.constant = indentAmount
    }
    
    func handleLinkClicked(tag: Tag, linkHandler: @escaping (URL) -> Void) {
        for attribute in tag.attributes {
           
            if attribute.key == "href" {
                if let url = URL(string: attribute.value) {
                    linkHandler(url)
                }
                break
            }
        }
    }

}
