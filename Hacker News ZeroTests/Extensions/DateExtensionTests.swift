//
//  DateExtensionTests.swift
//  Hacker News ZeroTests
//
//  Created by Matt Stanford on 4/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import XCTest
@testable import Hacker_News_Zero

class DateExtensionTests: XCTestCase {
    
    func testExample() {
       
        let mockNow = Date(timeIntervalSince1970: 1520780267)
        
        let second = Date(timeIntervalSince1970: 1520780268)
        XCTAssertEqual(second.getStringofTimePassedSinceDate(referenceDate: mockNow), "1 second")
        
        let seconds = Date(timeIntervalSince1970: 1520780270)
        XCTAssertEqual(seconds.getStringofTimePassedSinceDate(referenceDate: mockNow), "3 seconds")
        
        let minute = Date(timeIntervalSince1970: 1520780328)
        XCTAssertEqual(minute.getStringofTimePassedSinceDate(referenceDate: mockNow), "1 minute")
        
        let minutes = Date(timeIntervalSince1970: 1520780508)
        XCTAssertEqual(minutes.getStringofTimePassedSinceDate(referenceDate: mockNow), "4 minutes")
        
        let hour = Date(timeIntervalSince1970: 1520783868)
        XCTAssertEqual(hour.getStringofTimePassedSinceDate(referenceDate: mockNow), "1 hour")
        
        let hours = Date(timeIntervalSince1970: 1520798268)
        XCTAssertEqual(hours.getStringofTimePassedSinceDate(referenceDate: mockNow),"5 hours")
        
        let day = Date(timeIntervalSince1970: 1520866668)
        XCTAssertEqual(day.getStringofTimePassedSinceDate(referenceDate: mockNow), "1 day")
        
        let days = Date(timeIntervalSince1970: 1521298668)
        XCTAssertEqual(days.getStringofTimePassedSinceDate(referenceDate: mockNow), "6 days")
        
    }
    
  
    
}
