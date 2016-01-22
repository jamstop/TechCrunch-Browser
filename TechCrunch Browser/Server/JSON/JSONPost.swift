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
    let imageUrl: String?
    let likeCount: Int?
    
    init?(json: JSON) {
        self.ID = "ID" <~~ json
        self.author = "author" <~~ json
        self.date = "date" <~~ json
        self.title = "title" <~~ json
        self.content = "content" <~~ json
        self.likeCount = "like_count" <~~ json
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
