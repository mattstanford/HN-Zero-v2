//
//  Shareable.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 7/5/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

protocol Shareable {}

extension Shareable where Self:UIViewController {
    
    func share(article: Article) {
        let msg = getShareText(for: article)
        let shareSheet = UIActivityViewController(activityItems: [msg], applicationActivities: nil)
        shareSheet.popoverPresentationController?.sourceView = view
        present(shareSheet, animated: true, completion: nil)
    }
    
    private func getShareText(for article: Article) -> String {
        
        var shareString = article.title
        let commentPageUrl = "https://news.ycombinator.com/item?id=\(article.id)"
        
        if let url = article.url {
            shareString.append(": \(url)")
        }
        
        shareString.append("\n\nHN Discussion: \(commentPageUrl)")
        shareString.append("\n\nShared with www.hackernewszero.com")
        
        return shareString
    }
    
}
