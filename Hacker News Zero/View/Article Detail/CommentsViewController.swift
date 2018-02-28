//
//  CommentsViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, ArticleViewable {
    
    var navigator: ArticleNavigator?
    var currentShowingArticle: Article?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCurrentArticle()
    }

    //MARK: ArticleViewable protocol
    
    func gotNewArticle() {
        //TODO
    }
   

}
