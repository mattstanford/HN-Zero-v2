//
//  CommentItemViewModel.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/10/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

class CommentItemViewModel {
    
    let comment: Comment
    let level: Int
    
    init(with comment: Comment, level: Int) {
        self.comment = comment
        self.level = level
    }
}
