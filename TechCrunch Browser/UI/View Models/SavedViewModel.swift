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
    
    enum LoadError: ErrorType {
        case NoResponse
        case NothingSaved
    }
    
    let disposeBag = DisposeBag()
    
    let realm = try! Realm()
    
    var categories = List<RealmCategory>()
    var posts = List<RealmPost>()
    
    func loadSavedItems() -> Observable<AnyObject> {
        return Observable.create { observer in
            if self.realm.objects(RealmSavedCategories).count != 0 {
                self.categories = self.realm.objects(RealmSavedCategories)[0].categories
                observer.onCompleted()
            }
            
            if self.realm.objects(RealmSavedPosts).count != 0 {
                self.posts = self.realm.objects(RealmSavedPosts)[0].posts
                observer.onCompleted()
            }
            observer.onError(LoadError.NothingSaved)
            
            return NopDisposable.instance
        }
    }
    
    
}
