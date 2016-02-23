//
//  ArticleView.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/25/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage


class ArticleView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleAuthor: UILabel!
    @IBOutlet weak var articleContent: UILabel!
    
    var view: UIView!
    
    let realm = try! Realm()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        xibSetup()
    }
    
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        setupArticle()
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ArticleView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    private func setupArticle() {
        
        // Fetches current article from Realm
        let currentPost = realm.objects(RealmCurrentPost)[0].post!
        
        articleImage.sd_setImageWithURL(NSURL(string: (currentPost.imageUrl))!, placeholderImage: nil, options: .HighPriority)
        print(currentPost.title)
        articleTitle.text = currentPost.title.decodeHTMLEntities().decodedString
        articleAuthor.text = "by " + currentPost.author
        articleContent.text = currentPost.content.parseArticleContent()


    }
    
    
    
    
}
