//
//  SavedViewModel.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 2/2/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class SavedViewModel {
    
    let disposeBag = DisposeBag()
    
    let realm = try! Realm()
    
    var categories: List<RealmCategory>!
    var posts: List<RealmPost>!
    
    func loadSavedItems() {
        if realm.objects(RealmSavedCategories).count != 0 {
            categories = realm.objects(RealmSavedCategories)[0].categories
        }
        
        if realm.objects(RealmSavedPosts).count != 0 {
            posts = realm.objects(RealmSavedPosts)[0].posts
        }
    }
    
    
}
