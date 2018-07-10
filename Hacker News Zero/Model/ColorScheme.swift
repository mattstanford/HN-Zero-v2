//
//  ColorScheme.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 6/11/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

enum ColorScheme: String {
    case standard
    case dark
    
    var barColor: UIColor {
        switch self {
        case .standard:
            return .orange
        case .dark:
            return .black
        }
    }
    
    var barTextColor: UIColor {
        switch self {
        case .standard:
            return UIColor.white
        case .dark:
            return UIColor.white
        }
    }
    
    var contentBackgroundColor: UIColor {
        switch self {
        case .standard:
            return UIColor.white
        case .dark:
            return #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
        }
    }
    
    var contentTextColor: UIColor {
        switch self {
        case .standard:
            return UIColor.black
        case .dark:
            return #colorLiteral(red: 0.9215686275, green: 0.9607843137, blue: 0.9725490196, alpha: 1)
        }
    }
    
    var contentInfoTextColor: UIColor {
        switch self {
        case .standard:
            return UIColor.lightGray
        case .dark:
            return UIColor.gray
        }
    }
    
    //Color of checkmark in options, link color, "(OP)" color
    var accentColor: UIColor {
        switch self {
        case .standard:
            return UIColor.blue
        case .dark:
            return #colorLiteral(red: 0.1294117647, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
        }
    }
    
    var displayTitle: String {
        switch self {
        case .standard:
            return "HN Zero Classic"
        case .dark:
            return "Dark Mode"
        }
    }
}
