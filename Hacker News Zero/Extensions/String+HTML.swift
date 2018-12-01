//
//  String+HTML.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/29/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Atributika
import Foundation

extension String {

    func htmlText(colorScheme: ColorScheme,
                  fontName: String = AppConstants.defaultFont,
                  fontSize: CGFloat = AppConstants.defaultFontSize) -> AttributedText {

        let baseStyle = Style.foregroundColor(colorScheme.contentTextColor)

        var styles = [Style]()
        styles.append(Style("b").font(.boldSystemFont(ofSize: fontSize)))
        styles.append(Style("i").font(.italicSystemFont(ofSize: fontSize)))
        styles.append(Style("a").underlineStyle(NSUnderlineStyle.single).foregroundColor(colorScheme.accentColor, .normal).foregroundColor(.brown, .highlighted) )

        if let courierFont = Font(name: "Courier", size: fontSize) {
            styles.append(Style("code").font(courierFont))
        }

        var tempString = self
        tempString = tempString.replacingOccurrences(of: "<p>", with: "<br><br>")
        tempString = tempString.replacingOccurrences(of: "</code>", with: "</code><br>")
        tempString = tempString.trimmingCharacters(in: .whitespacesAndNewlines)

        tempString = tempString.stringWithDecodedHTMLEntities

        return tempString.style(tags: styles).styleAll(baseStyle)
    }

    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringWithDecodedHTMLEntities: String {

        // ===== Utility functions =====

        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string: Substring, base: Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }

        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity: Substring) -> Character? {

            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return nil
            }
        }

        // ===== Method starts here =====

        var result = ""
        var position = startIndex

        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound

            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = self[position...].range(of: ";") else {
                // No matching ';'.
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound

            if let decoded = decode(entity) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(contentsOf: entity)
            }
        }
        // Copy remaining characters to `result`:
        result.append(contentsOf: self[position...])
        return result
    }

}
