//
//  NetworkManager.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 1/25/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

let baseUrl = "https://hacker-news.firebaseio.com/v0/"
let jsonSuffix = ".json"
let topStoriesEndpoint = "topstories"
let itemEndpoint = "item/"

class HackerNewsApiClient : ApiClient
{
    var session = SessionManager()
    
    func getArticleIds() -> Observable<[Int]>
    {
        let endpoint = baseUrl + topStoriesEndpoint + jsonSuffix
        return RxAlamofire.requestJSON(.get, endpoint)
            .map({ (response, json) -> [Int] in
                
                guard let arrayOfStoryIds = json as? [Int] else
                {
                    return []
                }
            
                return arrayOfStoryIds
            })
    }
    
    func getArticleData(articleId : Int) -> Observable<Article?>
    {
        let endpoint = self.getItemEndpoint(itemId: articleId)
        
        return RxAlamofire.requestData(.get, endpoint)
            .map({ (response, jsonData) -> Article? in
                
                let article = Article.decodeArticleFrom(jsonData: jsonData)
                return article
            })
    }
    
    func getCommentData(itemId: Int) -> Observable<Comment> {
        let endpoint = self.getItemEndpoint(itemId: itemId)
        
        return session.rx.responseData(.get, endpoint)
            .map { (response, jsonData) -> Comment in
                
                guard let comment = Comment.decodeComment(from: jsonData) else {
                    print("json parsing error, creating empty comment!")
                    return Comment.createEmptyComment()
                }
                
                return comment
        }
    }
}

//MARK: Private helper functions
extension HackerNewsApiClient {
    
    func getItemEndpoint(itemId: Int) -> String
    {
        return baseUrl + itemEndpoint + String(itemId) + jsonSuffix
    }
}
