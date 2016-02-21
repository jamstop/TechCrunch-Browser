//
//  CategoryViewController.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 2/1/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import RxSwift
import Gloss
import RealmSwift

class CategoryViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    private let API = TechcrunchAPI()
    
    var category: RealmCategory!
    
    var currentOffset = 0
    
    var isSaved = false {
        didSet {
            if isSaved {
                saveCategoryButton.image = UIImage(named: "Remove")
            }
            
            else {
                saveCategoryButton.image = UIImage(named: "Add")
            }
        }
    }
    
    var newPosts: [JSONPost] = []
    var realmPosts: [RealmPost] = []
    
    let realm = try! Realm()
    let realmHelper = RealmHelper()
    
    let saveAlert = UIAlertController(title: "Subscribe to category?", message: "You will receive push notifications when new posts are added.", preferredStyle: .Alert)
    let unsaveAlert = UIAlertController(title: "Unsubscribe from category?", message: "You will stop receiving notifications from this category.", preferredStyle: .Alert)
    
    enum LoadingState {
        case Idle
        case Loading
        case Refreshing
        case LoadingMore
    }
    
    var currentState = LoadingState.Loading
    
    // MARK: - Properties
    
    @IBOutlet weak var mainView: FeedView!
    
    @IBOutlet weak var saveCategoryButton: UIBarButtonItem!
    
    @IBAction func saveCategoryPressed(sender: AnyObject) {
        if isSaved {
            presentViewController(unsaveAlert, animated: true, completion: nil)
        }
        else {
            presentViewController(saveAlert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        loadFeed()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if realmHelper.categoryIsSaved(category) {
            isSaved = true
        }
    }
    
    // MARK: - Helpers
    
    private func setup() {
        
        category = realm.objects(RealmCurrentCategory)[0].category
        
        // table view setup
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.refreshControl.addTarget(self, action: "pullToRefresh:", forControlEvents: .ValueChanged)
        
        // Etc. setup
        currentState = .Loading
        mainView.startInitialLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 128/255, blue: 128/255, alpha: 1.0)
        self.navigationItem.title = category.name
        
        saveAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { Void in
            self.saveCategory()
        }))
        saveAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        
        unsaveAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { Void in
            self.unsaveCategory()
        }))
        unsaveAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        
    }
    
    func saveCategory() {
        realmHelper.saveCategory(category)
        isSaved = true
    }
    
    func unsaveCategory() {
        realmHelper.unsaveCategory(category)
        isSaved = false
    }
    
    func pullToRefresh(sender: UIRefreshControl) {
        if currentState == .Idle {
            currentOffset = 0
            newPosts = []
            realmPosts = []
            
            currentState = .Refreshing
            loadFeed()
        }
    }
    
    private func loadFeed() {
        API.rx_loadLatestNewsByOffsetByCategory(currentOffset, category: category.slug).map { jsonResp -> [JSONPost] in
            print(self.category)
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
                    //                    self.commitFeedToPersistence()
                    
                    switch self.currentState {
                    case .Idle:
                        print("Cannot load without command")
                        
                    case .Loading:
                        self.mainView.endInitialLoad()
                        
                    case .Refreshing:
                        self.mainView.finishRefreshing()
                        
                    case .LoadingMore:
                        self.mainView.endLoadMore()
                    }
                    
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

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return screenWidth
        }
        return screenWidth/3
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if currentState == .Idle && newPosts.count % 10 == 0{
                currentState = .LoadingMore
                mainView.startLoadMore()
                loadFeed()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentPost = RealmCurrentPost()
        
        print(indexPath.row)
        print(realmPosts.count)
        currentPost.post = realmPosts[indexPath.row]
        currentPost.id = 0
        
        try! realm.write {
            realm.add(currentPost, update: true)
        }
        
        currentPost.post!.content.parseArticleContent()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("segueToArticleFromCategory", sender: self)
        
        
    }
    
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: PostTableViewCell!
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("FeaturedPostTableViewCell") as! PostTableViewCell
            
        }
            
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as! PostTableViewCell
        }
        
        if indexPath.row < newPosts.count {
            //            if indexPath.row < realmPosts.count {
            //                if let _ = realmPosts[indexPath.row].imageData {
            //                    cell.realmPost = realmPosts[indexPath.row]
            //                    return cell
            //                }
            //            }
            
            cell.post = newPosts[indexPath.row]
            
            // Make sure that the post is properly aligned in its place
            if indexPath.row == realmPosts.count{
                realmPosts.append(cell.persistedPost)
            }
        }
        
        
        return cell
        
    }
}

