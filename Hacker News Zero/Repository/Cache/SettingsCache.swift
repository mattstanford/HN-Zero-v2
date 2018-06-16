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
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        self.colorScheme = ColorScheme.standard
    }
    
   
    
    
}
