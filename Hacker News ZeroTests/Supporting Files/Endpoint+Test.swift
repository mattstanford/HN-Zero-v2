//
//  Endpoint+Test.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 12/2/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

@testable import Hacker_News_Zero

extension Endpoint {
    var defaultTestFileName: String {
        switch self {
        case .item(let itemId):
            return "item_\(itemId)"
        case .storylist(let storyType):
            switch storyType {
            case .frontpage:
                return "stories_top"
            case .askhn:
                return "stories_ask"
            case .showhn:
                return "stories_show"
            case .jobs:
                return "stories_job"
            case .new:
                return "stories_new"
            }
        }
    }
}
