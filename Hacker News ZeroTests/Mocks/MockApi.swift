//
//  MockApi.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 4/17/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import RxSwift
@testable import Hacker_News_Zero

class MockApi: ApiClient {
    func getArticleIds(type: ArticleType) -> Observable<Data> {
        guard let articleData = DataHelper.jsonDataFromFile(named: "ArticleList") else {
            return Observable.just(Data())
        }
        return Observable.just(articleData)
    }
    
    func getArticleData(articleId: Int) -> Observable<Data> {
        guard let articleData = DataHelper.jsonDataFromFile(named: "Article-Story") else {
            return Observable.just(Data())
        }
        return Observable.just(articleData)
    }
    
    func getCommentData(itemId: Int) -> Observable<Data> {
        guard let commentData = DataHelper.jsonDataFromFile(named: "Comment") else {
            return Observable.just(Data())
        }
        return Observable.just(commentData)
    }
    
    
}

// MARK: Utility functions
extension MockApi {
    
   
}
