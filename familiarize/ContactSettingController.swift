//
//  TermsPrivacyController.swift
//  familiarize
//
//  Created by Alex Oh on 7/2/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
class ContactSettingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Contact"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "ProximaNovaSoft-Regular", size: 20)!]
        
        collectionView?.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.white
        
        setupNavBarButton()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func setupNavBarButton() {
        let backButton = UIBarButtonItem(image: UIImage(named:"back-button")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
}
