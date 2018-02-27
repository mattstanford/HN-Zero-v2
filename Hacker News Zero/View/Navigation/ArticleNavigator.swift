//
//  ArticleNavigator.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/26/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class ArticleNavigator {
    
    var splitView: UISplitViewController!
    var articleList: ArticleViewController!
    var articleDetail: ArticleContainerViewController!
    
    init(with splitView: UISplitViewController, articleList: ArticleViewController, articleDetail: ArticleContainerViewController) {
        
        self.splitView = splitView
        self.articleList = articleList
        self.articleDetail = articleDetail
    }
    
    func show(article: Article) {
        
        print("showing article: " + article.title)
        
        guard let navController = articleDetail.navigationController else {
            return
        }
        
        splitView.show(navController, sender: nil)
    }
    
}
