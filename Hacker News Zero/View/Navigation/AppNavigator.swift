//
//  ArticleNavigator.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/26/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class AppNavigator {
    
    private var mainViewController: MainViewController
    private var articleList: ArticleViewController!
    private var articleDetail: ArticleContainerViewController!
    
    var currentArticle: Article?
    
    init(with mainView: MainViewController,
         articleList: ArticleViewController,
         articleDetail: ArticleContainerViewController) {
        
        self.mainViewController = mainView
        self.articleList = articleList
        self.articleDetail = articleDetail
    }
    
    func show(article: Article, selectedView: SelectedView) {
        
        print("showing article: " + article.title)
        currentArticle = article
        
        guard let navController = articleDetail.navigationController else {
            return
        }
        
        var view = selectedView
        
        //"Ask HN" type articles don't have a url
        if article.url == nil {
            view = .comments
        }
        
        //Job types usually don't have comments
        if article.numComments == nil {
            view = .web
        }
        
        articleList.showDetailViewController(navController, sender: nil)
        articleDetail.showArticle(in: view)
    }
    
    func toggleMenu() {
        mainViewController.toggleMenu()
    }
}
