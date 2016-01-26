//
//  PostTableViewCell.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/21/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class PostTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var postedBy: UILabel!
    @IBOutlet weak var title: UILabel!
    
    let realm = try! Realm()
    
    var persistedPost: RealmPost!
    
    var post: JSONPost? {
        didSet {

            
            thumbnail.sd_setImageWithURL(NSURL(string: (post?.imageUrl!)!)!, placeholderImage: nil, options: .HighPriority)
            
            
            postedBy.text = post?.name.stringByDecodingHTMLEntities
            title.text = post?.title?.stringByDecodingHTMLEntities
            
            persistedPost = RealmPost()
            persistedPost.title = post!.title!
            persistedPost.id = post!.ID!
            persistedPost.author = postedBy.text!
            persistedPost.content = post!.content!
            persistedPost.imageUrl = (post?.imageUrl)!
            
        }
    }

    
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
