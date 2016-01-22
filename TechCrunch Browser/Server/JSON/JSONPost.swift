//
//  JSONPost.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/21/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import Gloss


struct JSONPost: Decodable {
    
    // MARK: Properties
    
    let ID: String?
    let author: JSONAuthor?
    let date: String?
    let title: String?
    let content: String?
    let excerpt: String?
    let imageUrl: String?
    let likeCount: Int?
    
    init?(json: JSON) {
        self.ID = "ID" <~~ json
        self.author = "author" <~~ json
        self.date = "date" <~~ json
        self.title = "title" <~~ json
        self.content = "content" <~~ json
        self.excerpt = "excerpt" <~~ json
        self.likeCount = "like_count" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "ID" ~~> self.ID,
            "author" ~~> self.author,
            "date" ~~> self.date,
            "title" ~~> self.title,
            "content" ~~> self.content,
            "excerpt" ~~> self.excerpt,
            "imageUrl" ~~> self.imageUrl,
            "likeCount" ~~> self.likeCount
            ])
    }
}
