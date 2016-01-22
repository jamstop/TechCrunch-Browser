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
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "PostTableViewCell")
        
    }
    
}
