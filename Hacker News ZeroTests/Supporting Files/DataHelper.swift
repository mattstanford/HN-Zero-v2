//
//  DataHelper.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 4/17/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

class DataHelper {
    static func jsonDataFromFile(named name: String) -> Data? {
        
        let testBundle = Bundle(for: DataHelper.self)
        guard let url = testBundle.url(forResource: name, withExtension: "json") else {
            return nil
        }
        
        return try? Data(contentsOf: url)
    }
}
