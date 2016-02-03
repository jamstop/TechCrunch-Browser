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
    let unsaveAlert = UIAlertController(title: "Unsubscribe from post?", message: "", preferredStyle: .Alert)
    
    let realm = try! Realm()
    let realmHelper = RealmHelper()
    
    var isSaved = false {
        didSet {
            if isSaved {
                savePostButton.image = UIImage(named: "Unsave")
            }
                
            else {
                savePostButton.image = UIImage(named: "Saved")
            }
        }
    }
    
    @IBOutlet weak var savePostButton: UIBarButtonItem!
    
    @IBAction func savePostPressed(sender: AnyObject) {
        if isSaved {
            presentViewController(unsaveAlert, animated: true, completion: nil)
        }
        else {
            presentViewController(saveAlert, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 128/255, blue: 128/255, alpha: 1.0)
        
        saveAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { Void in
            self.savePost()
        }))
        saveAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        
        unsaveAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { Void in
            self.unsavePost()
        }))
        unsaveAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
    }
    
    override func viewWillAppear(animated: Bool) {
        if realmHelper.postIsSaved(realm.objects(RealmCurrentPost)[0].post!) {
            isSaved = true
        }
    }
    
    func savePost() {
        let post = realm.objects(RealmCurrentPost)[0].post
        realmHelper.savePost(post!)
        isSaved = true
    }
    
    func unsavePost() {
        let post = realm.objects(RealmCurrentPost)[0].post
        realmHelper.unsavePost(post!)
        isSaved = false
    }
}
