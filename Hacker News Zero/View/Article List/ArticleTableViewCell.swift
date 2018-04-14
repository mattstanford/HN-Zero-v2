//
//  ArticleTableViewCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/5/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var numCommentsLabel: UILabel!
    
    func configure(for viewModel: ArticleViewModel)
    {
        titleLabel.text = viewModel.article.title
        // cell.detailLabel.text = "44 points * 14 hours * nytimes.com * 14 hours"
        detailLabel.text = viewModel.getTimeString()
        
        if let numComments = viewModel.article.numComments
        {
            numCommentsLabel.text = String(describing:numComments)
        }
        
    }
}
