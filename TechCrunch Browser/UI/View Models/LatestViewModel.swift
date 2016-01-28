//
//  LatestViewModel.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/28/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import Foundation
import RxSwift
import Gloss
import RealmSwift

class LatestViewModel {
    
    var disposeBag = DisposeBag()
    
    let screenHeight = UIScreen.mainScreen().bounds.width
    private let API = TechcrunchAPI()
    
    var newPosts: [JSONPost] = []
    var realmPosts: [RealmPost] = []
    
    let category = "Latest"
    
    var currentOffset = 0
    
    let realm = try! Realm()
    
    enum LoadingState {
        case Idle
        case Loading
        case Refreshing
        case LoadingMore
    }
    
    var currentState = LoadingState.Loading
    
    
    func loadFeed() {
        API.rx_loadLatestNewsByOffset(currentOffset).map { jsonResp -> [JSONPost] in
            guard let postJSONArray = jsonResp["posts"] else {
                throw TechcrunchAPI.APIError.ErrorParsingJSON
            }
            
            guard let posts = JSONPost.modelsFromJSONArray(postJSONArray as! [JSON]) else {
                throw TechcrunchAPI.APIError.ErrorParsingJSON
            }
            
            return posts
            
            }.subscribe (
                onNext: { (posts) -> Void in
                    self.newPosts.appendContentsOf(posts)
//                    switch self.currentState {
//                    case .Idle:
//                        print("Cannot load without command")
//                        
//                    case .Loading:
//                        self.mainView.endInitialLoad()
//                        
//                    case .Refreshing:
//                        self.mainView.finishRefreshing()
//                        
//                    case .LoadingMore:
//                        self.mainView.endLoadMore()
//                    }
                    
                    self.currentState = .Idle
                    self.currentOffset += 20
                },
                onError: { (error) -> Void in
                    print(error)
                },
                onCompleted: { () -> Void in
                    print("Completed")
                },
                onDisposed: { () -> Void in
                    
            })
            .addDisposableTo(disposeBag)
    }

}