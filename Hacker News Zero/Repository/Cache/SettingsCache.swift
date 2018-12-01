//
//  SettingsCache.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 6/15/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

class SettingsCache {

    let userDefaults: UserDefaults
    var selectedArticleType: ArticleType = .frontpage

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    var colorScheme: ColorScheme {
        get {
            if let savedThemeString = userDefaults.string(forKey: "selectedTheme"),
                let theme = ColorScheme(rawValue: savedThemeString) {
                    return theme
            } else {
                return ColorScheme.standard
            }
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
