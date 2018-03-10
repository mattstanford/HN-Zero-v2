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

class HackerNewsApiClient : ApiClient
{
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
    
    func getAllComments(for article: Article) -> Observable<[Comment]>
    {
        return Observable.from(article.topLevelComments)
            .flatMap { id in
                return self.doGetComment(for: id)
            }
            .toArray()
    }
    
    func doGetComment(for commentId: Int) -> Observable<Comment> {
        
        let endpoint = self.getItemEndpoint(itemId: commentId)
        
        let observable: Observable<Comment> = RxAlamofire.requestData(.get, endpoint)
            .map { (response, jsonData) -> Comment in

                guard let comment = Comment.decodeComment(from: jsonData) else {
                    throw NetworkError.jsonParsingError
                }

                return comment
            }
            .flatMap { comment in

                return Observable.from(comment.childCommentIds)
                    .flatMap { id in
                        return self.doGetComment(for: id)
                    }
                    .toArray()
                    .map { childComments -> Comment in

                        var myComment = comment
                        myComment.childComments = childComments

                        return myComment
                    }
        }
        
        
        return observable
    }
}

//MARK: Private helper functions
extension HackerNewsApiClient {
    
    func getItemEndpoint(itemId: Int) -> String
    {
        return baseUrl + itemEndpoint + String(itemId) + jsonSuffix
    }
}
