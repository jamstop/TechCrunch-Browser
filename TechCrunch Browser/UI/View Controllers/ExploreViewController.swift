//
//  SearchViewController.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/26/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Gloss
import RealmSwift

class ExploreViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let screenHeight = UIScreen.mainScreen().bounds.width
    private let API = TechcrunchAPI()
    
    let category = "Search"
    
    var currentOffset = 0
    var currentQuery = ""
    
    var newPosts: [JSONPost] = []
    var realmPosts: [RealmPost] = []
    
    var categories: [JSONCategory] = []
    var realmCategories: [RealmCategory] = []
    
    let realm = try! Realm()
    
    enum LoadingState {
        case Idle
        case Loading
    }
    
    var currentState = LoadingState.Idle
    
    // MARK: - Properties
    
    @IBOutlet weak var mainView: ExploreView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        currentState = .Idle
        mainView.searching()
        
        mainView.startCategoryLoad()
        loadCategories()
    }
    
    // MARK: - Helpers
    
    private func setup() {
        
        // table view setup
        mainView.searchTableView.delegate = self
        mainView.searchTableView.dataSource = self
        mainView.categoriesTableView.delegate = self
        mainView.categoriesTableView.dataSource = self
        mainView.searchBar.delegate = self
        
        configureSearchBar()
        
    }
    
    private func reset() {
        currentOffset = 0
        newPosts = []
        realmPosts = []
    }
    
    func configureSearchBar() {
        //        let scheduler = MainScheduler.instance
        
        mainView.searchBar.rx_text
            .asDriver()
            .throttle(0.3)
            .distinctUntilChanged()
            .driveNext { query in
                if query != "" {
                    self.currentState = .Loading
                    self.mainView.searching()
                    LoadingHUD.sharedHUD.showInView(self.view)
                    self.reset()
                    self.currentQuery = query
                    self.searchArticles()
                } else {
                    self.mainView.searching()
                    self.currentState = .Idle
                }
            }
            .addDisposableTo(disposeBag)
        
        
    }
    
    private func loadCategories() {
        API.rx_getCategories().map { jsonResp -> [JSONCategory] in
            guard let categoryJSONArray = jsonResp["categories"] else {
                throw TechcrunchAPI.APIError.ErrorParsingJSON
            }
            
            guard let categories = JSONCategory.modelsFromJSONArray(categoryJSONArray as! [JSON]) else {
                throw TechcrunchAPI.APIError.ErrorParsingJSON
            }
            
            return categories
            
        }.subscribe (
            onNext: { (categories) -> Void in
                self.categories.appendContentsOf(categories)
                self.mainView.endCategoryLoad()
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
    
    private func searchArticles() {
        API.rx_loadPageWithQueryAndOffset(currentQuery, offset: currentOffset).map { jsonResp -> [JSONPost] in
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
                    
                    self.mainView.searched()
                    self.mainView.searchTableView.hidden = false
                    self.mainView.endLoadMore()
                    
                    self.currentState = .Idle
                    self.currentOffset += 20
                    
                    LoadingHUD.sharedHUD.hide()
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
}

// MARK: - UITableViewDelegate

extension ExploreViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return screenHeight/5
        }

        return screenHeight/3
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        dismissKeyboard()
        if scrollView.tag == 1 {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if currentState == .Idle && newPosts.count % 20 == 0 {
                    currentState = .Loading
                    mainView.startLoadMore()
                    searchArticles()
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 0 {
            let currentCategory = RealmCurrentCategory()
            dismissKeyboard()
            currentCategory.category = realmCategories[indexPath.row]
            currentCategory.id = 0
            
            try! realm.write {
                realm.add(currentCategory, update: true)
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            self.performSegueWithIdentifier("segueToCategory", sender: self)
        }
        if tableView.tag == 1 {
            let currentPost = RealmCurrentPost()
            dismissKeyboard()
            print(indexPath.row)
            print(realmPosts.count)
            currentPost.post = realmPosts[indexPath.row]
            currentPost.id = 0
            
            try! realm.write {
                realm.add(currentPost, update: true)
            }
            
            currentPost.post!.content.parseArticleContent()
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            self.performSegueWithIdentifier("segueToArticleFromSearch", sender: self)
        }
        
        
    }
    
}

// MARK: - UITableViewDataSource

extension ExploreViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView.tag == 0 {
            return categories.count
        }
        return newPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            var cell: CategoryTableViewCell!
            
            cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableViewCell") as! CategoryTableViewCell
            
            if indexPath.row < categories.count {
                cell.category = categories[indexPath.row]
                
                if indexPath.row == realmCategories.count{
                    realmCategories.append(cell.persistedCategory)
                }
            }
            
            return cell
        }
        
        var cell: PostTableViewCell!
        
        cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as! PostTableViewCell

        if indexPath.row < newPosts.count {
            cell.post = newPosts[indexPath.row]
            
            // Make sure that the post is properly aligned in its place
            if indexPath.row == realmPosts.count{
                realmPosts.append(cell.persistedPost)
            }
        }
        
        
        return cell
        
    }
}


// MARK: - UISearchBarDelegate

extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        dismissKeyboard()
    }
}



