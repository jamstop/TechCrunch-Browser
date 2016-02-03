//
//  ArticleViewController.swift
//  TechCrunch Browser
//
//  Created by Jimmy Yue on 1/25/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import RealmSwift

class ArticleViewController: UIViewController {
    
    let saveAlert = UIAlertController(title: "Subscribe to post?", message: "", preferredStyle: .Alert)
    
    let realm = try! Realm()
    let realmHelper = RealmHelper()
    
    @IBAction func savePostPressed(sender: AnyObject) {
        presentViewController(saveAlert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 128/255, blue: 128/255, alpha: 1.0)
        
        saveAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { Void in
            self.savePost()
        }))
        saveAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
    }
    
    func savePost() {
        let post = realm.objects(RealmCurrentPost)[0].post
        realmHelper.savePost(post!)
    }
}
