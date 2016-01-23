//
//  PostTableViewCell.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/21/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var postedBy: UILabel!
    @IBOutlet weak var title: UILabel!
    
//    var post: JSONPost? {
//        didSet {
//            post["
//            mentor?.image.bindTo(profileImage.bnd_image)
//            mentor?.userName.bindTo(name.bnd_text)
//            mentor?.userJobTitle.bindTo(jobTitle.bnd_text)
//            mentor?.userAbout.bindTo(summary.bnd_text)
//            canConnect = User.currentUser()?.isUserConnectedWithMentor(mentor!)
//        }
//    }
    
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
