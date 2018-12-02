//
//  Endpoint.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/12/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

enum Endpoint {
    case storylist(articleType: ArticleType)
    case item(itemId: Int)

    var path: String {
        switch self {
        case .storylist(let articleType):
            return baseUrl + articleType.endpointPath + jsonSuffix
        case .item(let itemId):
            return baseUrl + itemEndpoint + String(itemId) + jsonSuffix
        }
    }

}

extension Endpoint: Hashable, Equatable {
    static func == (lhs: Endpoint, rhs: Endpoint) -> Bool {
        switch (lhs, rhs) {
        case let (.item(leftId), .item(rightId)):
            return leftId == rightId
        case let (.storylist(leftType), .storylist(rightType)):
            return leftType == rightType
        default:
            return false
        }
    }

    var hashValue: Int {
        switch self {
        case .item(let itemId):
            return "item".hashValue ^ itemId.hashValue
        case .storylist(let storyType):
            return storyType.hashValue
        }
    }
}
