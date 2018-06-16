//
//  ArticleViewModel.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import RxSwift

class ArticleViewModel
{
    let article : Article
    let colorScheme: ColorScheme
    private let dateGenerator: () -> Date
    
    init(article: Article, colorScheme: ColorScheme, dateGenerator: @escaping () -> Date = Date.init)
    {
        self.article = article
        self.dateGenerator = dateGenerator
        self.colorScheme = colorScheme
    }
    
    var iconUrl: URL? {
        let domain = article.domain ?? ""
        return URL(string:"https://www.google.com/s2/favicons?domain=" + domain)
    }
    
    var detailLabelText: String {
        var text = ""
        
        //Sore (job stories don't have scores)
        if article.articleType != "job" {
            text += String(describing: article.score) + " point"
            if article.score != 1 { text += "s" }
            text += " • "
        }
        
        //Time
        text += timeString
        
        return text
    }
    
    private var timeString: String
    {
        let now = dateGenerator()
        let timePosted = article.timePosted
        
        return now.getStringofTimePassedSinceDate(referenceDate: timePosted)
    }
    
    
}
