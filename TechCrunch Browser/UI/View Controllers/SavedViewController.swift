//
//  SavedViewController.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 2/2/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class SavedViewController: UIViewController {
    
    let realm = try! Realm()
    
    let disposeBag = DisposeBag()
    
    let viewModel = SavedViewModel()
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    @IBOutlet weak var mainView: SavedView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        LoadingHUD.sharedHUD.showInView(mainView)

    }
    
    override func viewWillAppear(animated: Bool) {
        load()
        mainView.savedTableView.reloadData()
    }
    
    private func setup() {
        mainView.savedTableView.delegate = self
        mainView.savedTableView.dataSource = self
    }
    
    private func load() {
        viewModel.loadSavedItems().subscribe(
            onCompleted: { () -> Void in
                LoadingHUD.sharedHUD.hide()
                self.mainView.savedTableView.reloadData()
                EmptyFeedHUD.sharedHUD.hide()
            },
            onError: { error in
                LoadingHUD.sharedHUD.hide()
                EmptyFeedHUD.sharedHUD.showInView(self.mainView)
        })
        .addDisposableTo(disposeBag)
    }


}

extension SavedViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Category table view cell height
        if indexPath.section == 0 {
            return screenWidth/5
        }
        
        // Post table view cell height
        return screenWidth/3

        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! CategoryTableViewCell
            let currentCategory = RealmCurrentCategory()
            currentCategory.category = selectedCell.realmCategory
            currentCategory.id = 0
            
            try! realm.write {
                realm.add(currentCategory, update: true)
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            self.performSegueWithIdentifier("segueToCategory", sender: self)
        }
        
        else {
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! PostTableViewCell
            
            let currentPost = RealmCurrentPost()
            currentPost.post = selectedCell.realmPost
            currentPost.id = 0
            
            try! realm.write {
                realm.add(currentPost, update: true)
            }
            
            currentPost.post!.content.parseArticleContent()
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            self.performSegueWithIdentifier("segueToArticle", sender: self)
        }
        
        
    }
    
}

extension SavedViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return viewModel.categories.count
        }
        
        return viewModel.posts.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Categories
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableViewCell") as! CategoryTableViewCell
            cell.realmCategory = viewModel.categories[indexPath.row]
            return cell
        }
        
        // Posts
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as! PostTableViewCell
            cell.realmPost = viewModel.posts[indexPath.row]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Saved Categories"
        }
        
        return "Saved Posts"
    }
    
    
}
