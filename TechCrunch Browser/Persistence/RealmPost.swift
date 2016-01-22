//
//  RealmPost.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/20/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import RealmSwift

class RealmPost: Object {
    dynamic var id = ""
    dynamic var author = ""
    dynamic var date = ""
    dynamic var title = ""
    dynamic var content = ""
    dynamic var excerpt = ""
    dynamic var likes = 0
    dynamic var imageUrl = ""
    dynamic var category: RealmCategory?
    dynamic var favorited = false
    
}
