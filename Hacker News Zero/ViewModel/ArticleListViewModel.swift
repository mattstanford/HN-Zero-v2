//
//  ArticleListViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

class ArticleListViewModel
{
    let articleViewModels = [ArticleViewModel]()
    let repository : HackerNewsRepository
    
    init(repository: HackerNewsRepository)
    {
        self.repository = repository
    }
    
    
}
