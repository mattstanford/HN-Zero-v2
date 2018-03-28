//
//  CommentTableViewCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/27/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!
    
    func configure(with viewModel: CommentItemViewModel) {
        self.headerLabel.text = viewModel.getCommentHeaderText()
        self.contentLabel.text = viewModel.getContent()
    }

}
