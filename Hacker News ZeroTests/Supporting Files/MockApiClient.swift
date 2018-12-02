//
//  MockApiClient.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 12/1/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import RxSwift

@testable import Hacker_News_Zero

class MockApiClient: ApiClient {
    var customEndpointResponses: [Endpoint: String] = [:]

    func getArticleIds(type: ArticleType) -> Observable<Data> {
        let endpoint = Endpoint.storylist(articleType: type)

        return getJsonDataFrom(fileName: "ArticleList")
    }

    func getArticleData(articleId: Int) -> Observable<Data> {
        return getJsonDataFrom(fileName: "Article-Story")
    }

    func getCommentData(itemId: Int) -> Observable<Data> {
        return getJsonDataFrom(fileName: "Comment")
    }

    private func getJsonDataFrom(fileName: String) -> Observable<Data> {
        return Observable.create { observer in

            guard let jsonData = DataHelper.jsonDataFromFile(named: fileName) else {
                observer.onError(NetworkError.jsonTestFileNotFound)
                return Disposables.create()
                }
            observer.onNext(jsonData)
            observer.onCompleted()

            return Disposables.create()
        }
    }

}
