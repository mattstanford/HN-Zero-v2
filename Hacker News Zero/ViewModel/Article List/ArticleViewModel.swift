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
    
    init(article: Article)
    {
        self.article = article
    }
    
    var domain: String? {
        guard let urlString = article.url,
            let url = URL(string: urlString) else {
            return nil
        }
        
        return url.host
    }
    
    var iconUrl: URL? {
        
        guard let domain = domain else {
            return nil
        }
        
        return URL(string:"https://www.google.com/s2/favicons?domain=" + domain)
    }
    
    func getTimeString() -> String
    {
        var timeString = ""
        let now = Date()
        let timePosted = article.timePosted
        
        var difference =  Int(now.timeIntervalSince(timePosted))
        
        //Is it minutes?
        if difference > 60
        {

            difference = difference / 60
            
            //Is it hours?
            if difference > 60
            {
                difference = difference / 60
                
                //Is it days?
                if difference > 23
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
            
            //Should the time units be in plural?
            if difference > 1
            {
                timeString += "s"
            }
            
            return timeString
        }
        
      
        
        return timeString
    }
}
