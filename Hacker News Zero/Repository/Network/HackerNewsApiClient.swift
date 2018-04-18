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
let askHnEndpoint = "askstories"
let showHnEndpoint = "showstories"
let jobsEndpoint = "jobstories"
let newEndpoint = "newstories"
let itemEndpoint = "item/"

class HackerNewsApiClient : ApiClient
{
    var session = SessionManager()
    
    func getArticleIds(type: ArticleType) -> Observable<Data> {
        let endpoint = baseUrl + type.endpointPath + jsonSuffix
        
        return RxAlamofire.requestData(.get, endpoint)
            .map({ (response, jsonData) -> Data in
                
                return jsonData
            })
        
//        return RxAlamofire.requestJSON(.get, endpoint)
//            .map { (response, json) -> JSON in
//                
//                guard let jsonArray = json as? JSON else {
//                    throw NetworkError.jsonParsingError
//                }
//                
//                return jsonArray
//        }
    }
    
    
    func getArticleData(articleId : Int) -> Observable<Data>
    {
        let endpoint = self.getItemEndpoint(itemId: articleId)
        
        return RxAlamofire.requestData(.get, endpoint)
            .map({ (response, jsonData) -> Data in
                
                return jsonData
            })
    }
    
    func getCommentData(itemId: Int) -> Observable<Data> {
        let endpoint = self.getItemEndpoint(itemId: itemId)
        
        return session.rx.responseData(.get, endpoint)
            .map { (response, jsonData) -> Data in
                
                return jsonData
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
