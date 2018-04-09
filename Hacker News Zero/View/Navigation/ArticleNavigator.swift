//
//  ArticleNavigator.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/26/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class ArticleNavigator {
    
    var mainViewController: MainViewController
    var articleList: ArticleViewController!
    var articleDetail: ArticleContainerViewController!
    
    var currentArticle: Article?
    
    init(with mainView: MainViewController,
         articleList: ArticleViewController,
         articleDetail: ArticleContainerViewController) {
        
        self.mainViewController = mainView
        self.articleList = articleList
        self.articleDetail = articleDetail
    }
    
    func show(article: Article) {
        
        print("showing article: " + article.title)
        currentArticle = article
        
        guard let navController = articleDetail.navigationController else {
            return
        }
        
        articleList.showDetailViewController(navController, sender: nil)
        articleDetail.showNewArticle()
    }
}
