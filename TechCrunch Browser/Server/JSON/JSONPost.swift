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
    
    let ID: Int?
    let author: JSONAuthor?
    let date: String?
    let title: String?
    let content: String?
    let excerpt: String?
    let imageUrl: String?
    let likeCount: Int?
    
    var name: String!
    
    init?(json: JSON) {
        self.ID = "ID" <~~ json
        self.author = "author" <~~ json
        self.date = "date" <~~ json
        self.title = "title" <~~ json
        self.content = "content" <~~ json
        self.excerpt = "excerpt" <~~ json
        self.imageUrl = "featured_image" <~~ json
        self.likeCount = "like_count" <~~ json
        
        name = (self.author?.firstName)! + " " + (self.author?.lastName)!
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "ID" ~~> self.ID,
            "author" ~~> self.author,
            "date" ~~> self.date,
            "title" ~~> self.title,
            "content" ~~> self.content,
            "excerpt" ~~> self.excerpt,
            "featured_image" ~~> self.imageUrl,
            "like_count" ~~> self.likeCount
            ])
    }
}
