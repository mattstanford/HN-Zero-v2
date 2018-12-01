//
//  File.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 4/21/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

class MockDate {
    var currentDate = Date()

    func getTestDate() -> Date {
        return currentDate
    }
}
