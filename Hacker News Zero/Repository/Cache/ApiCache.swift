//
//  ApiCache.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import RxSwift

class ApiCache
{
    var articleIds = [Int]()
    var articleDict = [Int: Article]()
    
    func saveArticleIds(articleIds: [Int]) -> Completable
    {
        return Completable.create{ completable in
            
            self.articleIds = articleIds
            
            completable(.completed)
            return Disposables.create {}
        }
    }
    
    func saveArticleData(article: Article) -> Completable
    {
        return Completable.create { completable in
            
            self.articleDict[article.id] = article
            
            completable(.completed)
            return Disposables.create {}
        }
    }
    
    func getArticleIds(startIndex: Int, endIndex: Int) -> Observable<Int>
    {
        return Observable.create { observer in
        
            for index in startIndex...endIndex {
        
                if index < self.articleIds.count{
                    
                    let articleId = self.articleIds[index]
                    observer.onNext(articleId)
                }
            }
            
            observer.onCompleted()
            return Disposables.create {}
        }
    }
    
    func getArticle(articleId: Int) -> Single<Article?>
    {
        return Single.just(articleDict[articleId]);
    }
}
