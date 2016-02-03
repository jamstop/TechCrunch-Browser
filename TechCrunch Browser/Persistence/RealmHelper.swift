//
//  RealmHelper.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/22/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import RealmSwift
import SDWebImage
import RxSwift

class RealmHelper {
    
    enum RealmError: ErrorType {
        case ErrorDownloadingImage(error: NSError)
        case ErrorParsingJSON(message: String)
        case UnexpectedError(message: String)
    }
    
    let realm = try! Realm()
    let downloader = SDWebImageDownloader()
    
    let disposeBag = DisposeBag()
    
    func postIsSaved(post: RealmPost) -> Bool {
        let saved = realm.objects(RealmSavedPosts)
        if saved.count == 0 {
            return false
        }
            
        else {
            for item in saved[0].posts {
                if item.id == post.id {
                    return true
                }
            }
            return false
        }
    }
    
    func categoryIsSaved(category: RealmCategory) -> Bool {
        let saved = realm.objects(RealmSavedCategories)
        if saved.count == 0 {
            return false
        }
        
        else {
            for item in saved[0].categories {
                if item.name == category.name {
                    return true
                }
            }
            return false
        }
    }
    
    func saveCategory(category: RealmCategory) {
        let saved = realm.objects(RealmSavedCategories)
        var savedCategories: RealmSavedCategories
        if saved.count == 0 {
            savedCategories = RealmSavedCategories()
            savedCategories.id = 0
        }
        else {
            savedCategories = saved[0]
        }
        
        for item in savedCategories.categories {
            if item.name == category.name {
                return
            }
        }
        
        try! realm.write({
            savedCategories.categories.append(category)
            realm.add(savedCategories, update: true)
        })
    }
    
    func savePost(post: RealmPost) {
        let saved = realm.objects(RealmSavedPosts)
        var savedPosts: RealmSavedPosts
        if saved.count == 0 {
            savedPosts = RealmSavedPosts()
            savedPosts.id = 0
        }
        else {
            savedPosts = saved[0]
        }
        
        for item in savedPosts.posts {
            if item.id == post.id {
                return
            }
        }
        
        try! realm.write({
            savedPosts.posts.append(post)
            realm.add(savedPosts, update: true)
        })
    }
    
    func unsaveCategory(category: RealmCategory) {
        if categoryIsSaved(category) {
            let savedCategories = realm.objects(RealmSavedCategories)[0].categories
            for x in 0..<savedCategories.count {
                if savedCategories[x] == category {
                    try! realm.write({
                        savedCategories.removeAtIndex(x)
                    })
                    return
                }
            }
        }
    }
    
    func unsavePost(post: RealmPost) {
        if postIsSaved(post) {
            let savedPosts = realm.objects(RealmSavedPosts)[0].posts
            for x in 0..<savedPosts.count {
                if savedPosts[x] == post {
                    try! realm.write({
                        savedPosts.removeAtIndex(x)
                    })
                    return
                }
            }
        }
    }
    
    
    
    func setPostsForCategory(categoryName: String, posts: [JSONPost]) -> Observable<RealmCategory> {
        
        let postNumber = posts.count
        var loaded = 0
        
        let category = RealmCategory()
        category.name = categoryName
        
        return Observable.create { observer in
            for post in posts {
                self.JSONPostToRealmPost(post).subscribe(
                    onNext: { post in
                        category.posts.append(post)
                        loaded += 1
                        if loaded == postNumber {
                            try! self.realm.write {
                                self.realm.add(category, update: true)
                            }
                            observer.onNext(category)
                        }
                    },
                    onError: { (error) -> Void in
                        print(error)
                    },
                    onCompleted: {
                        print("completed")
                    },
                    onDisposed: {
                        
                }).addDisposableTo(self.disposeBag)
            }
            return NopDisposable.instance
        }
        
    }
    
    // Conversion of JSONPost into a more cacheable format
    
    private func JSONPostToRealmPost(post: JSONPost) -> Observable<RealmPost> {
        let newPost = RealmPost()
        newPost.id = post.ID!
        newPost.author = (post.author?.firstName)! + " " + (post.author?.lastName)!
        newPost.date = post.date!
        newPost.title = post.title!
        newPost.excerpt = post.excerpt!
        newPost.imageUrl = post.imageUrl!
        
        return Observable.create { observer in
            self.downloader.downloadImageWithURL(NSURL(string: newPost.imageUrl), options: .HighPriority, progress: nil, completed: { image, data, error, finished in
                if let error = error {
                    observer.onError(RealmError.ErrorDownloadingImage(error: error))
                }
                
                newPost.imageData = data
                observer.onNext(newPost)
                
            })
            
        return NopDisposable.instance
            
        }
    }
    
}
