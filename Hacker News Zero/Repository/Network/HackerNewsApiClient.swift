//
//  NetworkManager.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 1/25/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Alamofire
import Foundation
import RxAlamofire
import RxSwift

let baseUrl = "https://hacker-news.firebaseio.com/v0/"
let jsonSuffix = ".json"
let topStoriesEndpoint = "topstories"
let askHnEndpoint = "askstories"
let showHnEndpoint = "showstories"
let jobsEndpoint = "jobstories"
let newEndpoint = "newstories"
let itemEndpoint = "item/"

class HackerNewsApiClient: ApiClient {
    let session: SessionManager

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 100
        session = SessionManager(configuration: configuration)
    }

    func getArticleIds(type: ArticleType) -> Observable<Data> {
        let path = Endpoint.storylist(articleType: type).path

        return session.rx.responseData(.get, path)
            .map({ _, jsonData -> Data in

                return jsonData
            })
    }

    func getArticleData(articleId: Int) -> Observable<Data> {
        let path = Endpoint.item(itemId: articleId).path

        return session.rx.responseData(.get, path)
            .map({ _, jsonData -> Data in

                return jsonData
            })
    }

    func getCommentData(itemId: Int) -> Observable<Data> {
         let path = Endpoint.item(itemId: itemId).path

        return session.rx.responseData(.get, path)
            .map { _, jsonData -> Data in

                return jsonData
            }
    }
}

// MARK: Private helper functions
extension HackerNewsApiClient {

    func getItemEndpoint(itemId: Int) -> String {
        return baseUrl + itemEndpoint + String(itemId) + jsonSuffix
    }
}
