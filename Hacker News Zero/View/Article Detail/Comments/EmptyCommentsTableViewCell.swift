//
//  EmptyCommentsTableViewCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 7/11/19.
//  Copyright © 2019 locacha. All rights reserved.
//

import UIKit

class EmptyCommentsTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!

    func configure(colorScheme: ColorScheme) {
        backgroundColor = colorScheme.contentBackgroundColor
        contentView.backgroundColor = colorScheme.contentBackgroundColor
        titleLabel.textColor = colorScheme.contentInfoTextColor
    }

}
