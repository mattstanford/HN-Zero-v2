//
//  NetworkError.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/9/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case jsonTestFileNotFound
    case jsonParsingError
    case unknownResponse
}

extension NetworkError: LocalizedError {
    var title: String {
        return "Error"
    }

    var localizedDescription: String {
        switch self {
        case .jsonTestFileNotFound:
            return "Couldn't find json test file"
        case .jsonParsingError:
            return "Error parsing JSON"
        case .unknownResponse:
            return "Unknown response"
        }
    }
}
