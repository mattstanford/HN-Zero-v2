//
//  ArticleTableViewCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/5/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    typealias CommentHandler = (Article) -> Void
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var numCommentsLabel: UILabel!
    @IBOutlet weak var commentsView: UIView!
    
    var commentHandler: CommentHandler?
    var viewModel: ArticleViewModel?
    
    func configure(for viewModel: ArticleViewModel, commentHandler: CommentHandler?)
    {
        self.viewModel = viewModel
        titleLabel.text = viewModel.article.title
        // cell.detailLabel.text = "44 points * 14 hours * nytimes.com * 14 hours"
        detailLabel.text = viewModel.getTimeString()
        
        if let numComments = viewModel.article.numComments
        {
            commentsView.isHidden = false
            numCommentsLabel.text = String(describing:numComments)
        }
        else
        {
            commentsView.isHidden = true
        }
        
        if let commentHandler = commentHandler {
            self.commentHandler = commentHandler
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedComments(_:)))
            commentsView.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    
    @objc func clickedComments(_ sender: UITapGestureRecognizer? = nil) {
        if let article = viewModel?.article {
            commentHandler?(article)
        }
    }
}
