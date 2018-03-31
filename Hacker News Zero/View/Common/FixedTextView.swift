//
//  FixedTextView.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/30/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

@IBDesignable class FixedTextView: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
