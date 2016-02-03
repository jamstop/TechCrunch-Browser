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
    let downloader = SDWebImageDownloader()
    
    var persistedPost: RealmPost!
    
    var post: JSONPost? {
        didSet {
//            print(realm.objects(RealmPost).filter("id = " + String(post?.ID))[0])

            
            thumbnail.sd_setImageWithURL(NSURL(string: (post?.imageUrl!)!)!, placeholderImage: nil, options: SDWebImageOptions.HighPriority, completed: { image, error, cache, finished in
//                self.persistedPost.imageData = UIImagePNGRepresentation(image)
            })
            
            self.persistedPost = RealmPost()
            self.persistedPost.title = self.post!.title!
            self.persistedPost.id = self.post!.ID!
            self.persistedPost.author = self.postedBy.text!
            self.persistedPost.content = self.post!.content!
            self.persistedPost.imageUrl = (self.post?.imageUrl)!
            
            postedBy.text = post?.name.stringByDecodingHTMLEntities
            title.text = post?.title?.stringByDecodingHTMLEntities
            
        }
    }
    
    var realmPost: RealmPost? {
        didSet {
            thumbnail.sd_setImageWithURL(NSURL(string: (realmPost?.imageUrl)!)!, placeholderImage: nil, options: SDWebImageOptions.HighPriority, completed: { image, error, cache, finished in
                //                self.persistedPost.imageData = UIImagePNGRepresentation(image)
            })
            postedBy.text = realmPost?.author
            title.text = realmPost?.title
            
            persistedPost = realmPost
            
            
//            thumbnail.image = UIImage(data: realmPost!.imageData!)
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
