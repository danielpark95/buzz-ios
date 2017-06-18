//
//  ViewController.swift
//  familiarize
//
//  Created by Alex Oh on 5/27/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import CoreData

extension Notification.Name {
    static let reload = Notification.Name("reloadNotification")
    static let viewProfile = Notification.Name("viewProfileNotification")
}

class ContactsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    var userProfiles: [UserProfile]?
    var refresher:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Contacts"
        userProfiles = UserProfile.getData()
        setupRefreshingAndReloading()
        setupCollectionView()

    }
    
    func viewProfileNotification() {
        self.viewProfile()
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        NotificationCenter.default.addObserver(self, selector: #selector(viewProfileNotification), name: .viewProfile, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewProfile(_ idx: Int = 0) {
        
        let viewProfileController = ViewProfileController()
        
        if let userProfile = userProfiles?[idx] {
            viewProfileController.userProfile = userProfile
        }
        
        viewProfileController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        // The defines 
        self.definesPresentationContext = true
        self.present(viewProfileController, animated: false)
    }
    
    
    func setupRefreshingAndReloading() {
        // This is like a signal. When the QRScanner VC clicks on add friend, this event fires, which calls refreshTableData
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reload, object: nil)
        
        //This is a different signal from the one written in notification center. This signal is fired whenever a user drags down the collection view in contacts.
        self.refresher = UIRefreshControl()
        self.refresher.addTarget(self, action: #selector(refreshTableData), for: UIControlEvents.valueChanged)
        collectionView?.refreshControl = refresher
        
    }
    
    func setupCollectionView() {
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha:1)
        collectionView?.register(ContactsCell.self, forCellWithReuseIdentifier: self.cellId)
    }
    
    func reloadTableData() {
        userProfiles = UserProfile.getData()
        collectionView?.reloadData()
    }
    
    func refreshTableData() {
        collectionView!.refreshControl?.beginRefreshing()
        collectionView?.reloadData()
        collectionView?.refreshControl?.endRefreshing()
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.userProfiles?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! ContactsCell
        
        if let userProfile = userProfiles?[indexPath.item] {
            cell.userProfile = userProfile
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewProfile(indexPath.item)
    }


}
