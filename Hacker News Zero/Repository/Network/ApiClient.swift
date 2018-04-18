//
//  HackerNewsApiClient.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import RxSwift

protocol ApiClient {
    func getArticleIds(type: ArticleType) -> Observable<Data>
    func getArticleData(articleId : Int) -> Observable<Data>
    func getCommentData(itemId: Int) -> Observable<Data>
}
