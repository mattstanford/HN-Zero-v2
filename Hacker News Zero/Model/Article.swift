//
//  Article.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 1/25/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

struct Article : Codable
{
    let id : Int
    let title : String
    let url : String?
    let score : Int
    let author : String
  //  let timePosted : Date
    let articleType : String
    let articlePostText : String?
    let numComments: Int?
    
//
    enum CodingKeys : String, CodingKey {
        case id
        case title
        case url
        case score
        case author = "by"
//        case timePosted = "time"
        case articleType = "type"
        case articlePostText = "text"
        case numComments = "descendants"
    }
    
}
