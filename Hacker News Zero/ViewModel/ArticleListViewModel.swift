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
    var articleViewModels = [ArticleViewModel]()
    let repository : HackerNewsRepository
    
    init(repository: HackerNewsRepository)
    {
        self.repository = repository
    }
    
    func getArticleListObservable() -> Completable
    {
        return repository.getArticleList()
            .map({ articleIds -> Bool in
                
                self.articleViewModels.removeAll()
                
                for articleId in articleIds
                {
                    let viewModel = ArticleViewModel(articleId: articleId, repository: self.repository)
                    self.articleViewModels.append(viewModel)
                }
                
                return true
            })
            .ignoreElements()
    }
}
