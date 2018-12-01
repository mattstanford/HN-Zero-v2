//
//  AttributedLabel+htmlText.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 4/12/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Atributika
import Foundation

extension AttributedLabel {

    func setHtmlText(text: String,
                     colorScheme: ColorScheme,
                     fontName: String = AppConstants.defaultFont,
                     fontSize: CGFloat = AppConstants.defaultFontSize,
                     linkHandler: @escaping (URL) -> Void) {
        numberOfLines = 0
        if let labelFont = Font(name: AppConstants.defaultFont, size: AppConstants.defaultFontSize) {
            font = labelFont
        }
        attributedText = text.htmlText(colorScheme: colorScheme)
        onClick = { label, detection in
            switch detection.type {
            case .tag(let tag):
                self.parseLinkClicked(tag: tag, linkHandler: linkHandler)
            default:
                print("something else!")
            }
        }
    }

    private func parseLinkClicked(tag: Tag, linkHandler: (URL) -> Void) {
        for attribute in tag.attributes {

            if attribute.key == "href" {
                if let url = URL(string: attribute.value) {
                    linkHandler(url)
                }
                break
            }
        }
    }

}
