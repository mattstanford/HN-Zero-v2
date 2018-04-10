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
            .flatMap { articleIds in
                return self.cache.saveArticleIds(articleIds: articleIds)
            }
            .ignoreElements()
    }
    
    func getArticles(for page:Int, pageSize:Int) -> Single<[Article?]>
    {
        let startIndex = page * pageSize
        let endIndex = (startIndex + pageSize) - 1
        
        return cache.getArticleIds(startIndex: startIndex, endIndex: endIndex)
            .flatMap { articleId in
                
                return self.apiClient.getArticleData(articleId: articleId)
            }
            .toArray()
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
                
                return Comment.setCommentsInProperOrder(idList: commentIds, commentList: comments)
        }
        
    }
    
    
}
