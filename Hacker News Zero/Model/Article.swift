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
    let timePosted : Date
    let articleType : String
    let articlePostText : String?
    let numComments: Int?
    let topLevelComments: [Int]
    

    enum CodingKeys : String, CodingKey {
        case id
        case title
        case url
        case score
        case author = "by"
        case timePosted = "time"
        case articleType = "type"
        case articlePostText = "text"
        case numComments = "descendants"
        case topLevelComments = "kids"
    }
    
    static func decodeArticleFrom(jsonData: Data) -> Article?
    {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let article = try? decoder.decode(Article.self, from: jsonData)

        return article
    }
}
