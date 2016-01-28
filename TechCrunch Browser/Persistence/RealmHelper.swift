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
    
    func setPostsForCategory(categoryName: String, posts: [JSONPost]) ->  {
        
        let postNumber = posts.count
        
        let category = RealmCategory()
        category.name = categoryName
        
        return Observable.create { observer in
            
        }
        
        return NopDisposable.instance
        
        
        for post in posts {
            
        }
        
        
    }
    
    // Conversion of JSONPost into a more cacheable format
    
    func JSONPostToRealmPost(post: JSONPost) -> Observable<RealmPost> {
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
