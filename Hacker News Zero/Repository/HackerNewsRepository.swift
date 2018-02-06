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
    
    func getArticle(articleId: Int) -> Observable<Article?>
    {
        return cache.getArticle(articleId: articleId)
            .flatMap({ (cachedArticle) -> Observable<Article?> in
                
                if (cachedArticle == nil)
                {
                    return self.apiClient.getArticleData(articleId: articleId)
                }
                else
                {
                    return Observable.just(cachedArticle)
                }

            })
    }
    
    func getArticleList() -> Observable<[Int]>
    {
        return self.apiClient.getArticleList()
    }
    
}
