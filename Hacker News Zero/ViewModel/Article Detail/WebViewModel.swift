//
//  WebViewModel.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

class WebViewModel {
    var currentUrl: URL? {
        willSet(newUrl) {
            needsReset = true
        }
    }
    
    var article: Article? {
        willSet(newArticle) {
            
            guard let newArticle = newArticle else {
                return
            }
            
            if let oldArticle = article,
                oldArticle.id == newArticle.id {
                
                //Trying to load the same article, don't do anything
                needsReset = false
            } else {
           
                guard let urlString = newArticle.url,
                    let url = URL(string: urlString) else {
                        return
                }
                
                //New article, need to reset
                currentUrl = url
                needsReset = true
            }
        }
    }
    var needsReset: Bool = true
    
    
}
