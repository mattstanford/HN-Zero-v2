//
//  Comment.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/9/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

struct Comment: Codable {
    
    let id: Int
    let parentId: Int
    let author: String
    let text: String
    let childCommentIds: [Int]
    var childComments: [Comment]
    //let time: Date
    
    enum CodingKeys : String, CodingKey {
        case id
        case parentId = "parent"
        case author = "by"
        case text
        case childCommentIds = "kids"
        case childComments
    }
    
    static func decodeComment(from jsonData: Data) -> Comment?
    {
        let decoder = JSONDecoder()
      //  decoder.dateDecodingStrategy = .secondsSince1970
        let comment = try? decoder.decode(Comment.self, from: jsonData)
        
        return comment
    }
}
