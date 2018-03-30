//
//  String+HTML.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/29/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation

extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data,
                                          options:[NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)

        }catch{
            return NSAttributedString()
        }
    }
    
    func htmlText(fontName: String, fontSize: Int) -> NSAttributedString {
        
        guard let data = data(using: .utf8),
         var tempString = String(data: data, encoding: .utf8) else {
            return NSAttributedString()
            
        }
        
        tempString = tempString.replacingOccurrences(of: "<p>", with: "<br><br>")
        tempString = tempString.replacingOccurrences(of: "</code>", with: "</code><br>")
        tempString = tempString.trimmingCharacters(in: .whitespacesAndNewlines)
       
        let wrappedString = String(format: "<span style=\"font-family: \(fontName); font-size: \(fontSize)\">\(tempString)</span>")
        
        guard let wrappedData = wrappedString.data(using: .utf8, allowLossyConversion: true) else {
            return NSAttributedString()
        }
        
        do {
        
        return try NSAttributedString(data: wrappedData,
                                      options:[NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        }
        catch {
            return NSAttributedString()
        }
        
      
    }
}
