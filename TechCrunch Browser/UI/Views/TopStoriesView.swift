//
//  TopStoriesView.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/21/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit

class TopStoriesView: UIView {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
    }
    
    func startInitialLoad() {
        tableView.hidden = true
        tableView.alpha = 0
        LoadingHUD.sharedHUD.showInView(self)

    }
    
    func endInitialLoad() {
        tableView.hidden = false
//        UIView.animateWithDuration(
        
    }
    
}
