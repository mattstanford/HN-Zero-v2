//
//  CommentTableViewCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/27/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!
    
    func configure(with viewModel: CommentItemViewModel) {
        self.authorLabel.text = viewModel.getAuthorText()
        self.contentLabel.text = viewModel.getContent()
    }

}
