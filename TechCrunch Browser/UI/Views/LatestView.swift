//
//  LatestView.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/21/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import RealmSwift

class LatestView: UIView {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    // MARK: - Awake from nib
    
    override func awakeFromNib() {
        setupTableView()
        
        
    }
    
    private func setupTableView () {
        
        // register nib
        let postNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.registerNib(postNib, forCellReuseIdentifier: "PostTableViewCell")
        
        let featuredPostNib = UINib(nibName: "FeaturedPostTableViewCell", bundle: nil)
        tableView.registerNib(featuredPostNib, forCellReuseIdentifier: "FeaturedPostTableViewCell")
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 1, green: 128/255, blue: 128/255, alpha: 1.0)
        tableView.addSubview(refreshControl)
        
    }
    
    func startInitialLoad() {
        tableView.hidden = true
        tableView.alpha = 0
        LoadingHUD.sharedHUD.showInView(self)

    }
    
    func endInitialLoad() {
        LoadingHUD.sharedHUD.hide()
        tableView.hidden = false
        UIView.animateWithDuration(0.5, animations: {
            self.tableView.alpha = 1
        })
        tableView.reloadData()
        
        
    }
    
    func startLoadMore() {
//        LoadingHUD.sharedHUD.showInView(self)
    }
    
    func endLoadMore() {
        LoadingHUD.sharedHUD.hide()
        tableView.reloadData()
    }
    
    func finishRefreshing() {
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
}
