//
//  SearchView.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/25/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit

class ExploreView: UIView {
    
    // MARK: Properties
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Awake from nib
    
    override func awakeFromNib() {
        setupTableView()
        setupSearchBar()
        
    }
    
    private func setupTableView () {
        
        // register nib
        let postNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        searchTableView.registerNib(postNib, forCellReuseIdentifier: "PostTableViewCell")
        
        let categoryNib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        categoriesTableView.registerNib(categoryNib, forCellReuseIdentifier: "CategoryTableViewCell")
        
    }
    
    private func setupSearchBar () {
        searchBar.returnKeyType = UIReturnKeyType.Done
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    func startCategoryLoad() {
        categoriesTableView.hidden = true
        categoriesTableView.alpha = 0
    }
    
    func endCategoryLoad() {
        categoriesTableView.hidden = false
        UIView.animateWithDuration(0.5, animations: {
            self.categoriesTableView.alpha = 1
        })
        categoriesTableView.reloadData()
        
        
    }
    
    func searching() {
        searchTableView.hidden = true
        searchTableView.alpha = 0
        
        
    }
    
    func searched() {
        searchTableView.hidden = false
        UIView.animateWithDuration(0.5, animations: {
            self.searchTableView.alpha = 1
        })
        searchTableView.reloadData()
        
        
    }
    
    func startLoadMore() {
        //        LoadingHUD.sharedHUD.showInView(self)
    }
    
    func endLoadMore() {
        LoadingHUD.sharedHUD.hide()
        searchTableView.reloadData()
    }
    
}
