//
//  ApiCache.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import RxSwift

class ApiCache
{
    let articleDict = [Int: Article]()
    
    func getArticle(articleId: Int) -> Observable<Article?>
    {
        return Observable.just(articleDict[articleId]);
    }
}
