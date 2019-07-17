//
//  EmptyCommentsTableViewCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 7/11/19.
//  Copyright © 2019 locacha. All rights reserved.
//

import UIKit

class EmptyCommentsTableViewCell: UITableViewCell {

    var repository = HackerNewsRepository.shared

    @IBOutlet var titleLabel: UILabel!

    func configure() {
        backgroundColor = repository.currentColorScheme.contentBackgroundColor
        contentView.backgroundColor = repository.currentColorScheme.contentBackgroundColor
        titleLabel.textColor = repository.currentColorScheme.contentInfoTextColor
    }

}
