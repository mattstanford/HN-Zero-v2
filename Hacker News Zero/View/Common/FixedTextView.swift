//
//  FixedTextView.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/30/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

//Inspired by: https://stackoverflow.com/a/42333832/3772113
@IBDesignable class FixedTextView: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0

        var boundsCopy = bounds
        let fitHeight = sizeThatFits(CGSize(
            width: bounds.size.width,
            height: CGFloat.greatestFiniteMagnitude)
            ).height
        boundsCopy.size.height = fitHeight
        bounds = boundsCopy
    }
}
