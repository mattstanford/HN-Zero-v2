//
//  Date+DisplayString.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 4/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

extension Date {
    
    func getStringofTimePassedSinceDate(referenceDate: Date) -> String {
        
        var timeString = ""
        var difference = Int(self.timeIntervalSince(referenceDate))
        
        //Is it minutes?
        if difference > 60
        {
            difference = difference / 60
            
            //Is it hours?
            if difference >= 60
            {
                difference = difference / 60
                
                //Is it days?
                if difference >= 24
                {
                    difference = difference / 24
                    timeString = "\(difference) day"
                }
                else
                {
                    timeString = "\(difference) hour"
                }
            }
            else
            {
                timeString = "\(difference) minute"
            }
        }
        else
        {
            timeString = "\(difference) second"
        }
        
        //Should the time units be in plural?
        if difference > 1
        {
            timeString += "s"
        }
        
        return timeString
    }
    
}
