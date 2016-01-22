//
//  JSONAuthor.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/21/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import Gloss


struct JSONAuthor: Decodable {
    
    // MARK: Properties
    
    let ID: String?
    let firstName: String?
    let lastName: String?
    let avatarUrl: String?
    
    init?(json: JSON) {
        self.ID = "ID" <~~ json
        self.firstName = "first_name" <~~ json
        self.lastName = "last_name" <~~ json
        self.avatarUrl = "avatar_URL" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "ID" ~~> self.ID,
            "first_name" ~~> self.firstName,
            "last_name" ~~> self.lastName,
            "avatar_URL" ~~> self.avatarUrl
            ])
    }
}
