//
//  RealmCategory.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/20/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCategory: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var slug = ""
    let posts = List<RealmPost>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}