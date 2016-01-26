//
//  SearchView.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/25/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit

class SearchView: UIView {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Awake from nib
    
    override func awakeFromNib() {
        setupTableView()
        setupSearchBar()
        
    }
    
    private func setupTableView () {
        
        // register nib
        let postNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.registerNib(postNib, forCellReuseIdentifier: "PostTableViewCell")
        
    }
    
    private func setupSearchBar () {
        searchBar.returnKeyType = UIReturnKeyType.Done
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    func startInitialLoad() {
        tableView.hidden = true
        tableView.alpha = 0
        
    }
    
    func endInitialLoad() {
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
    
}
