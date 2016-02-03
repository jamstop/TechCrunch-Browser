//
//  SavedViewController.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 2/2/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import RxSwift

class SavedViewController: UIViewController {
    
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
