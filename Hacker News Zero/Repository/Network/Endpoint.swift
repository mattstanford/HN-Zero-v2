//
//  Endpoint.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/12/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

enum Endpoint
{
    case storylist(storyType: StoryType)
    case item(itemId: Int)
    
}