//
//  LoadingSpinnerCell.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 8/14/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class LoadingSpinnerCell: UITableViewCell {
    @IBOutlet weak private var loadingSpinner: UIActivityIndicatorView!

    var repository = HackerNewsRepository.shared

    func configure() {

        loadingSpinner.color = repository.currentColorScheme.contentTextColor
        backgroundColor = repository.currentColorScheme.contentBackgroundColor

        loadingSpinner.startAnimating()
    }

}
