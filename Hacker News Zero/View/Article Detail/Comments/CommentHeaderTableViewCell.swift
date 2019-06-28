//
//  CommentHeaderTableViewCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 6/27/19.
//  Copyright © 2019 locacha. All rights reserved.
//

import Atributika
import UIKit

class CommentHeaderTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var postTextView: AttributedLabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var headerSeparatorView: UIView!

    func configure(viewModel: CommentsViewModel, linkClickedClosure: @escaping (URL) -> Void) {
        titleLabel.text = viewModel.article?.title
        titleLabel.textColor = viewModel.colorScheme.contentTextColor
        titleLabel.font = UIFont.systemFont(ofSize: AppConstants.defaultHeaderFontSize, weight: .semibold)
        infoLabel.text = viewModel.infoString
        infoLabel.textColor = viewModel.colorScheme.contentInfoTextColor
        headerSeparatorView.backgroundColor = viewModel.colorScheme.barColor

        if let postText = viewModel.article?.articlePostText,
            postText.count > 0 {
            postTextView.isHidden = false
            postTextView.backgroundColor = viewModel.repository.settingsCache.colorScheme.contentBackgroundColor
            postTextView.setHtmlText(text: postText, colorScheme: viewModel.colorScheme, linkHandler: linkClickedClosure)

        } else {
            postTextView.isHidden = true
        }
    }

}
