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
    private let dateGenerator: () -> Date
    
    init(article: Article, dateGenerator: @escaping () -> Date = Date.init)
    {
        self.article = article
        self.dateGenerator = dateGenerator
    }
    
    var iconUrl: URL? {
        
        guard let domain = article.domain else {
            return nil
        }
        
        return URL(string:"https://www.google.com/s2/favicons?domain=" + domain)
    }
    
    var detailLabelText: String {
        var text = ""
        
        //Sore
        text += String(describing: article.score) + " point"
        if article.score != 1 { text += "s" }
        text += " • "
        
        //Time
        text += timeString
        
        return text
    }
    
    var timeString: String
    {
        var timeString = ""
        let now = dateGenerator()
        let timePosted = article.timePosted
        
        var difference =  Int(now.timeIntervalSince(timePosted))
        
        //Is it minutes?
        if difference > 60
        {
            difference = difference / 60
            
            //Is it hours?
            if difference >= 60
            {
                difference = difference / 60
                
                //Is it days?
                if difference >= 24
                {
                    difference = difference / 24
                    timeString = "\(difference) day"
                }
                else
                {
                    timeString = "\(difference) hour"
                }
            }
            else
            {
                timeString = "\(difference) minute"
            }
        }
        else
        {
            timeString = "\(difference) second"
        }
        
        //Should the time units be in plural?
        if difference > 1
        {
            timeString += "s"
        }
        
        return timeString
    }
    
    
}
