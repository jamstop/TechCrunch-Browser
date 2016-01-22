//
//  PostTableViewCell.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/21/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var postedBy: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var title: UILabel!
    
//    weak var delegate: FeedCellDelegate?
    
    // MARK: - Awake from nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
//    @IBAction func onProfileButtonTap(sender: AnyObject) {
//        
//        delegate?.performSegue(self)
//        
//    }

}
