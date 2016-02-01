//
//  CategoryTableViewCell.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/31/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    let realm = try! Realm()
    
    var persistedCategory: RealmCategory!
    
    var category: JSONCategory? {
        didSet {
            
            categoryLabel.text = category!.name?.stringByDecodingHTMLEntities
            
            persistedCategory = RealmCategory()
            persistedCategory.name = (category!.name?.stringByDecodingHTMLEntities)!
            persistedCategory.id = category!.ID!
            persistedCategory.slug = category!.slug!
            
        }
    }
    
    // MARK: - Awake from nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

