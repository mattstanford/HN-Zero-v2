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
    
    func getArticleIdArray(startIndex: Int, endIndex: Int) -> Observable<[Int]>
    {
        return Observable.create { observer in
            var idArray: [Int] = [Int]()
            
            if self.articleIds.count > startIndex {
                
                if self.articleIds.count >= endIndex {
                    idArray = Array(self.articleIds[startIndex...endIndex])
                } else {
                    idArray = Array(self.articleIds[startIndex...])
                }
                
            }
            
            observer.onNext(idArray)
            observer.onCompleted()
            
            return Disposables.create {}
        }
    }

    func getArticle(articleId: Int) -> Single<Article?>
    {
        return Single.just(articleDict[articleId]);
    }
}
