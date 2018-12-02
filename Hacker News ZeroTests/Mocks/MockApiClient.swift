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
    var customEndpointResponses: [String: String] = [:]

    func getArticleIds(type: ArticleType) -> Observable<Data> {
        return getTestJsonDataFor(endpoint: Endpoint.storylist(articleType: type))
    }

    func getArticleData(articleId: Int) -> Observable<Data> {
        return getTestJsonDataFor(endpoint: Endpoint.item(itemId: articleId))
    }

    func getCommentData(itemId: Int) -> Observable<Data> {
        return getTestJsonDataFor(endpoint: Endpoint.item(itemId: itemId))
    }

    private func getTestJsonDataFor(endpoint: Endpoint) -> Observable<Data> {
        return Observable.create { observer in

            let jsonFileToUse: String
            if let customFileName = self.customEndpointResponses[endpoint.path] {
                jsonFileToUse = customFileName
            } else {
                jsonFileToUse = endpoint.defaultTestFileName
            }

            guard let jsonData = DataHelper.jsonDataFromFile(named: jsonFileToUse) else {
                observer.onError(NetworkError.jsonTestFileNotFound)
                return Disposables.create()
                }
            observer.onNext(jsonData)
            observer.onCompleted()

            return Disposables.create()
        }
    }

}
