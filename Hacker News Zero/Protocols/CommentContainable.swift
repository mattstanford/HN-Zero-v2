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

extension CommentContainable {
    
    static func setCommentsInProperOrder(idList: [Int], commentList: [Comment]) -> [Comment]
    {
        //First place comments in a dictionary for fast access
        var commentsDict = [Int: Comment]()
        for comment in commentList {
            commentsDict[comment.id] = comment
        }
        
        //Now create an array of the comments in the intended order
        var orderedArray = [Comment]()
        for id in idList {
            if let comment = commentsDict[id] {
                orderedArray.append(comment)
            }
        }
        
        return orderedArray
    }
}
