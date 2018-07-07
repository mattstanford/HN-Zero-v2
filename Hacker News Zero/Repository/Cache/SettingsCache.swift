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
    var colorScheme: ColorScheme
    var selectedArticleType: ArticleType = .frontpage
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        self.colorScheme = ColorScheme.dark
    }
    
    var selectedTheme: ThemeSelection {
        get {
            if let savedThemeString = userDefaults.string(forKey: "selectedTheme"),
                let theme = ThemeSelection(rawValue: savedThemeString) {
                    return theme
            } else {
                return ThemeSelection.classic
            }
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
