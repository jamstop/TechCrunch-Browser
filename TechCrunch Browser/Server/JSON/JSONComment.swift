//
//  JSONComment.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/21/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import Gloss


struct JSONComment: Decodable {
    
    // MARK: Properties
    
    let ID: String?
    let post: JSONPost?
    let author: JSONAuthor?
    let date: String?
    let content: String?
    
    init?(json: JSON) {
        self.ID = "ID" <~~ json
        self.post = "post" <~~ json
        self.author = "author" <~~ json
        self.date = "date" <~~ json
        self.content = "content" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "ID" ~~> self.ID,
            "post" ~~> self.post,
            "author" ~~> self.author,
            "date" ~~> self.date,
            "content" ~~> self.content
            ])
    }
    
}