//
//  RealmCurrentCategory.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 2/1/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCurrentCategory: Object {
    dynamic var id = 0
    dynamic var category: RealmCategory?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
