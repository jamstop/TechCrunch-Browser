//
//  SavedView.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 2/2/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit

class SavedView: UIView {
    
    // MARK: Properties
    
    @IBOutlet weak var savedTableView: UITableView!
    
    // MARK: - Awake from nib
    
    override func awakeFromNib() {
        setupTableView()
        
    }
    
    private func setupTableView () {
        
        // register nib
        let postNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        let categoryNib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        
        savedTableView.registerNib(postNib, forCellReuseIdentifier: "PostTableViewCell")
        savedTableView.registerNib(categoryNib, forCellReuseIdentifier: "CategoryTableViewCell")
        
        
    }

    
}

