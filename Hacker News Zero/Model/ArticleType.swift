//
//  ArticleType.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/28/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

enum ArticleType {
    case frontpage
    case askhn
    case showhn
    case jobs
    case new
    
    var endpointPath: String {
        switch self {
        case .frontpage:
            return topStoriesEndpoint
        case .askhn:
            return askHnEndpoint
        case .showhn:
            return showHnEndpoint
        case .jobs:
            return jobsEndpoint
        case .new:
            return newEndpoint
        }
    }
}
