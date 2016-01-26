//
//  RealmCurrentPost.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/25/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCurrentPost: Object {
    dynamic var id = 0
    dynamic var post: RealmPost?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}