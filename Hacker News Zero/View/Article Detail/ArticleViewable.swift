//
//  ArticleViewable.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/27/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

protocol ArticleViewable: class {
    var navigator: ArticleNavigator? { get set }
    var currentShowingArticle: Article? { get set }
    
    func gotNewArticle()
}

extension ArticleViewable {
    
    func showCurrentArticle() {
        
        if navigator?.currentArticle?.id != currentShowingArticle?.id {
            
            currentShowingArticle = navigator?.currentArticle
            gotNewArticle()
        }
    }
}

