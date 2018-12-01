//
//  BottomBarHideable.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 7/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

protocol BottomBarHideable {
    var bottomBar: UIToolbar! { get set }
    var bottomBarBottomConstraint: NSLayoutConstraint! { get set }
}

extension BottomBarHideable where Self: UIViewController {

    func animateBar(show: Bool) {

        if show {
             bottomBarBottomConstraint.constant = 0
        } else {
            bottomBarBottomConstraint.constant = view.safeAreaInsets.bottom + bottomBar.frame.height
        }

        bottomBar.setNeedsUpdateConstraints()

        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
