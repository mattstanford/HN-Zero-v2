//
//  ModelHelper.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 7/17/19.
//  Copyright © 2019 locacha. All rights reserved.
//

@testable import Hacker_News_Zero

import Foundation

class ModelHelper {
    static func getArticle(from jsonFileName: String) -> Article? {
        guard let articleData = DataHelper.jsonDataFromFile(named: jsonFileName),
            let article = try? Article.decodeArticleFrom(jsonData: articleData) else {
                return nil
        }

        return article
    }
}
