//
//  RealmComment.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/20/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import RealmSwift

class RealmComment: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var avatar: NSData?
    dynamic var avatarUrl = ""
    dynamic var content = ""
    dynamic var date = ""
    dynamic var likecount = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
