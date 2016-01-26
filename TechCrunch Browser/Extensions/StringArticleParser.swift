//
//  StringArticleParser.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/25/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import Kanna
import UIKit

extension String {
    
    func parseArticleContent() -> String {
        
        var article = ""
        let htmlConvertedString = self.decodeHTMLEntities().decodedString
        
        if let doc = Kanna.HTML(html: htmlConvertedString, encoding: NSUTF8StringEncoding) {
            for paragraph in doc.css("p") {
                article += "    " + paragraph.text! + "\n\n"
            }
        }
        
        return article
        
    }
}
