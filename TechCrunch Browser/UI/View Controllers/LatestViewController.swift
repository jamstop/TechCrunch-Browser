//
//  LatestViewController.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/21/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import RxSwift
import Gloss

class LatestViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let screenHeight = UIScreen.mainScreen().bounds.width
    private let API = TechcrunchAPI()
    
    let category = "Latest"
    
    var currentOffset = 0
    
    var newPosts: [JSONPost] = []
    
    var loading = false
    
    // MARK: - Properties
    
    @IBOutlet weak var mainView: TopStoriesView!
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        loadFeed()


    }
    
    // MARK: - Helpers
    
    private func setup() {
        
        // table view setup
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
    }
    
    private func loadFeed() {
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
                },
                onError: { (error) -> Void in
                    print("Error logging in: \(error)")
                },
                onCompleted: { () -> Void in
                    print("Completed")
                },
                onDisposed: { () -> Void in
                    
            })
            .addDisposableTo(disposeBag)
    }

}

// MARK: - UITableViewDelegate

extension LatestViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return screenHeight
        }
        return screenHeight/3
    }

}

// MARK: - UITableViewDataSource

extension LatestViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FeaturedPostTableViewCell") as! FeaturedPostTableViewCell
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as! PostTableViewCell
        
        return cell
        
    }
}