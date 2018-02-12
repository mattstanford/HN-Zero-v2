//
//  ArticleListViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import RxSwift

class ArticleListViewModel
{
    let pageSize = 25
    var articleViewModels = [ArticleViewModel]()
    let repository : HackerNewsRepository
    
    init(repository: HackerNewsRepository)
    {
        self.repository = repository
    }
    
    func refreshArticles() -> Completable
    {
        return repository.refreshArticleList()
            .andThen(getPageOfArticles(pageNum: 0))
    }
    
    func getPageOfArticles(pageNum: Int) -> Completable
    {
        return repository.getArticles(for: pageNum, pageSize: pageSize)
            .map { articles -> Bool in
                
                //TODO: Map this to a better data structure
                self.articleViewModels = [ArticleViewModel]()
                
                for article in articles {
                    
                    if let article = article {
                        let viewModel = ArticleViewModel(article: article)
                        self.articleViewModels.append(viewModel)
                    }
                }
                
                return true
            }
            .asObservable()
            .ignoreElements()
    }
}
