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
}
