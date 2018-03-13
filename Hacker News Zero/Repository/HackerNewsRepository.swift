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
    
    func refreshArticleList() -> Completable
    {
        return apiClient.getArticleIds()
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
    
    func getComments(for article:Article) -> Observable<[Comment]> {
        return apiClient.getComments(from: article)
    }
    
    
}
