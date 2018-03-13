//
//  CommentContainable.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/12/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

protocol CommentContainable {
    var childCommentIds: [Int]? { get }
    var childComments : [Comment]? { get set }
}
