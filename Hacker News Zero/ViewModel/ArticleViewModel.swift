//
//  ArticleViewModel.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import RxSwift

class ArticleViewModel
{
    let articleId : Int
    var article : Article? = nil
    let repository : HackerNewsRepository
    
    init(articleId: Int, repository: HackerNewsRepository)
    {
        self.articleId = articleId
        self.repository = repository
    }
    
    func hasArticleData() -> Bool
    {
        return article != nil
    }
    
    func getArticleData() -> Completable
    {
        return repository.getArticle(articleId: self.articleId)
            .ignoreElements()
    }
}
