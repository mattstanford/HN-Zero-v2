//
//  ArticleTableViewCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/5/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Kingfisher
import UIKit

class ArticleTableViewCell: UITableViewCell {

    typealias CommentHandler = (ArticleViewModel) -> Void

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var numCommentsLabel: UILabel!
    @IBOutlet weak var commentsView: UIView!

    @IBOutlet weak var commentViewWidth: NSLayoutConstraint!

    var commentHandler: CommentHandler?
    var viewModel: ArticleViewModel?

    func configure(for viewModel: ArticleViewModel, commentHandler: CommentHandler?, colorScheme: ColorScheme) {
        self.viewModel = viewModel
        self.contentView.backgroundColor = colorScheme.contentBackgroundColor

        titleLabel.text = viewModel.article.title
        titleLabel.textColor = colorScheme.contentTextColor
        // cell.detailLabel.text = "44 points * 14 hours * nytimes.com * 14 hours"
        detailLabel.text = viewModel.detailLabelText
        detailLabel.textColor = colorScheme.contentInfoTextColor

        if let iconUrl = viewModel.iconUrl {
            iconImage.kf.setImage(with: iconUrl, placeholder: #imageLiteral(resourceName: "default_icon"))
        }

        if let numComments = viewModel.article.numComments {
            commentsView.isHidden = false
            commentViewWidth.constant = 50
            numCommentsLabel.text = String(describing: numComments)
            numCommentsLabel.textColor = colorScheme.contentTextColor
        } else {
            commentViewWidth.constant = 8
            commentsView.isHidden = true
        }

        if let commentHandler = commentHandler {
            self.commentHandler = commentHandler
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedComments(_:)))
            commentsView.addGestureRecognizer(gestureRecognizer)
        }
    }

    @objc func clickedComments(_ sender: UITapGestureRecognizer? = nil) {
        guard let viewModel = viewModel else {
            return
        }
        commentHandler?(viewModel)
    }
}
