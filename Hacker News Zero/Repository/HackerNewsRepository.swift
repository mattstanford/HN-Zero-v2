//
//  HackerNewsRepository.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import RxSwift

class HackerNewsRepository {
    
    let apiClient: ApiClient
    let cache: ApiCache
    
    init(client: ApiClient, cache: ApiCache)
    {
        self.apiClient = client
        self.cache = cache
    }
    
    func refreshArticleList(type: ArticleType) -> Completable
    {
        return apiClient.getArticleIds(type: type)
            .map { jsonData in
                
                guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments),
                let arrayOfStoryIds = jsonObject as? [Int] else {
                        throw NetworkError.jsonParsingError
                }
                
                return arrayOfStoryIds
            }
            .flatMap { articleIds in
                return self.cache.saveArticleIds(articleIds: articleIds)
            }
            
            .ignoreElements()
    }
    
    func getArticles(for page:Int, pageSize:Int) -> Single<[Article]>
    {
        let startIndex = page * pageSize
        let endIndex = (startIndex + pageSize) - 1
                
        return cache.getArticleIdArray(startIndex: startIndex, endIndex: endIndex)
            .flatMap { articleIds in
                return Observable.from(articleIds)
                    .flatMap { articleId in
                        
                        return self.apiClient.getArticleData(articleId: articleId)
                    }
                    .map { jsonData in
                        let article = try Article.decodeArticleFrom(jsonData: jsonData)
                        return article
                    }
                    .toArray()
                    .map { articleArray in
                        
                        return self.setItemsInProperOrder(idList: articleIds, itemList: articleArray)
                }
            }
            .asSingle()
    }
    
    func getComments(from container: CommentContainable) -> Observable<[Comment]> {
        
        guard let commentIds = container.childCommentIds else {
            return Observable.just([Comment]())
        }
        
        return Observable.from(commentIds)
            .flatMap { id in
                return self.apiClient.getCommentData(itemId: id)
            }
            .map { jsonData -> Comment in
                guard let comment = Comment.decodeComment(from: jsonData) else {
                    print("json parsing error, creating empty comment!")
                    return Comment.createEmptyComment()
                }
                
                return comment
            }
            .flatMap { comment -> Observable<Comment> in
                
                return self.getComments(from: comment)
                    .map { childComments in
                        
                        var myComment = comment
                        myComment.childComments = childComments
                        return myComment
                }
            }
            .toArray()
            .map { comments in
                
                return self.setItemsInProperOrder(idList: commentIds, itemList: comments)
        }
    }
}


//MARK - Helper functions
extension HackerNewsRepository {
    
    func setItemsInProperOrder<T: HackerNewsItemType>(idList: [Int], itemList: [T]) -> [T]
    {
        //First place comments in a dictionary for fast access
        var commentsDict = [Int: T]()
        for item in itemList {
            commentsDict[item.id] = item
        }
        
        //Now create an array of the comments in the intended order
        var orderedArray = [T]()
        for id in idList {
            if let comment = commentsDict[id] {
                orderedArray.append(comment)
            }
        }
        
        return orderedArray
    }
}
