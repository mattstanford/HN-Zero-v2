//
//  NetworkManager.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 1/25/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift

let baseUrl = "https://hacker-news.firebaseio.com/v0/"
let jsonSuffix = ".json"
let topStoriesEndpoint = "topstories"
let itemEndpoint = "item/"

class HackerNewsApiClient
{
    func getArticleList() -> Observable<[Int]>
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
            .map({ (response, jsonString) -> Article? in
                
                let decoder = JSONDecoder()
                let article = try? decoder.decode(Article.self, from: jsonString)

                return article
            })
    }
}

//MARK: Private helper functions
extension HackerNewsApiClient {
    
    func getItemEndpoint(itemId: Int) -> String
    {
        return baseUrl + itemEndpoint + String(itemId) + jsonSuffix
    }
}
