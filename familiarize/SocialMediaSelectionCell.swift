//
//  SocialMediaCell.swift
//  familiarize
//
//  Created by Alex Oh on 7/5/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit

class SocialMediaSelectionCell: UICollectionViewCell {

    var socialMedia: SocialMedia? {
        didSet {
            if let imageName = socialMedia?.imageName {
                socialMediaImage.image = UIImage(named: imageName)
            }
            setupViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let socialMediaImage: UIImageView = {
        let image = UIManager.makeImage()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    func setupViews() {
        backgroundColor = UIColor.white
        addSubview(socialMediaImage)
        socialMediaImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        socialMediaImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        socialMediaImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        socialMediaImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

class SocialMedia: NSObject {
    var imageName: String?
    var appName: String?
    var inputName: String?
    var isSet: Bool?
    
    init(withAppName appName: String, withImageName imageName: String, withInputName inputName: String, withAlreadySet isSet: Bool) {
        self.imageName = imageName
        self.appName = appName
        self.inputName = inputName
        self.isSet = isSet
    }
    
    init(copyFrom: SocialMedia) {
        self.imageName = copyFrom.imageName
        self.appName = copyFrom.appName
        self.inputName = copyFrom.inputName
        self.isSet = copyFrom.isSet
    }
}

