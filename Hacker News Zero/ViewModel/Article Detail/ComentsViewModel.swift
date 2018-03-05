//
//  ComentsViewModel.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

class CommentsViewModel {
    
    var article: Article?
    
    private let infoSeparator: String = "•"
    
    func getInfoString() -> String {
        //num commments * user * domain * time since
        var infoString = ""
        
        if let numComments = article?.numComments {
            infoString += String(numComments) + " " + "comments".localized
        }
        
        if infoString.count > 0 {
            infoString +=  " " + infoSeparator + " "
        }
        
        if let author = article?.author {
            infoString += author
        }

        
        return infoString
    }
    
}
