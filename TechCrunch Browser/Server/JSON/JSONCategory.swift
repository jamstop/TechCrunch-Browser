//
//  JSONCategory.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/21/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import Gloss


struct JSONCategory: Decodable {
    // MARK: Properties
    
    let ID: Int?
    let name: String?
    
    init?(json: JSON) {
        self.ID = "ID" <~~ json
        self.name = "name" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "ID" ~~> self.ID,
            "name" ~~> self.name
            ])
    }
}