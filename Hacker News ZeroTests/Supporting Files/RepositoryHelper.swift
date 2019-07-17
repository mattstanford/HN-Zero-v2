//
//  RepositoryHelper.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 7/16/19.
//  Copyright © 2019 locacha. All rights reserved.
//

import Foundation

@testable import Hacker_News_Zero

class RepositoryHelper {
    static func getTestRepository() -> HackerNewsRepository {
        return HackerNewsRepository(client: MockApiClient(),
                                    cache: ApiCache(),
                                    settingsCache: SettingsCache())
    }
}
