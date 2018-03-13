//
//  Comment.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/9/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

struct Comment: Codable, CommentContainable {

    let id: Int
    let parentId: Int
    let author: String?
    let text: String?
    let childCommentIds: [Int]?
    let isDead: Bool?
    //let time: Date
    
    //Not part of the JSON
    var childComments: [Comment]? = nil
    
    private enum CodingKeys : String, CodingKey {
        case id
        case parentId = "parent"
        case author = "by"
        case text
        case childCommentIds = "kids"
        case isDead = "dead"
        case childComments
    }
    
    static func decodeComment(from jsonData: Data) -> Comment?
    {
        let decoder = JSONDecoder()

      //  decoder.dateDecodingStrategy = .secondsSince1970
        let comment = try? decoder.decode(Comment.self, from: jsonData)
        return comment
    }
    
    static func createEmptyComment() -> Comment {
        return Comment(id: 0,
                       parentId: 0,
                       author: nil,
                       text: nil,
                       childCommentIds: nil,
                       isDead: nil,
                       childComments: nil)
    }
    
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
