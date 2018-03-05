//
//  WebViewModel.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

class WebViewModel {
    var article: Article? {
        willSet(newArticle) {
           
           if let newArticle = newArticle,
                let oldArticle = article,
                oldArticle.id == newArticle.id {
            
                needsReset = false
            
            }
           else {
                needsReset = true
            }
        }
    }
    var needsReset: Bool = true
    
    
}
