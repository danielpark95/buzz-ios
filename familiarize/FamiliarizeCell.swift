//
//  FamiliarizeCell.swift
//  familiarize
//
//  Created by Alex Oh on 6/1/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import QRCode
import SwiftyJSON
import UIKit

// You need to convert the JSON string to a data and then intialize it to create a json object! 


class FamiliarizeCell: UICollectionViewCell {

    
    var onQRImage: Bool = true
    var qrImageView: UIImageView?
    
    enum borderTag: Int {
        case val = 1
    }
    
    let shortHandForQR = [
        "bio": "bio",
        "faceBookProfile": "fb",
        "instagramProfile": "ig",
        "name": "name",
        "phoneNumber": "pn",
        "snapChatProfile": "sc" ,
        ]
    
    var myUserProfile: MyUserProfile? {
        didSet {
            // Views is set after knowing how long the texts are.
            
            // When myUserProfile is set within the UserController as a cell, then load up the required information that the user has.
            createQR(myUserProfile!)
            setupViews()
        }
    }
    
    func createJSON(_ profile: MyUserProfile) -> String {
        var jsonDict: [String: String] = [:]
        for key in (profile.entity.attributesByName.keys) {
            if (profile.value(forKey: key) != nil && shortHandForQR[key] != nil) {
                    jsonDict[shortHandForQR[key]!] = profile.value(forKey: key) as? String
            }
        }
        return JSON(jsonDict).rawString()!
    }
    
    func createQR(_ profile: MyUserProfile) {
        var qrCode = QRCode(self.createJSON(profile))
        qrCode?.color = CIColor.white()
        qrCode?.backgroundColor = CIColor(red:1.00, green: 0.52, blue: 0.52, alpha: 1.0)
        qrImageView = UIManager.makeImage()
        qrImageView?.image = qrCode?.image
    }
    
    lazy var cardBorder: UIImageView = {
        let image = UIManager.makeImage(imageName: "dan_card_border")
        image.tag = borderTag.val.rawValue
        return image
    }()
    
    let bioLabel: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        return label
        
    }()
    
    func flip() {
        
        for v in (self.subviews){
            if v.tag != borderTag.val.rawValue {
                v.removeFromSuperview()
            }
        }
        
        if onQRImage == true {
            addSubview(bioLabel)
            
            let bio = NSMutableAttributedString(string: "Palo Alto, 29, Coffee Enthusiast", attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 20)!, NSForegroundColorAttributeName: UIColor(red:1.00, green: 0.52, blue: 0.52, alpha: 1.0)])
            
            bioLabel.attributedText = bio
            
            bioLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            bioLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 30).isActive = true
            bioLabel.heightAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.height).isActive = true
            bioLabel.widthAnchor.constraint(equalToConstant:bioLabel.intrinsicContentSize.width).isActive = true
            presentSocialMediaButtons()
            
            onQRImage = false
        } else {
            addSubview(qrImageView!)
            qrImageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            qrImageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50).isActive = true
            qrImageView?.heightAnchor.constraint(equalToConstant: 200).isActive = true
            qrImageView?.widthAnchor.constraint(equalToConstant: 200).isActive = true
            onQRImage = true
        }
        
    }
    
    func setupViews() {
        addSubview(cardBorder)
        
        addSubview(qrImageView!)
        qrImageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        qrImageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50).isActive = true
        qrImageView?.heightAnchor.constraint(equalToConstant: 200).isActive = true
        qrImageView?.widthAnchor.constraint(equalToConstant: 200).isActive = true

        cardBorder.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cardBorder.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50).isActive = true
        cardBorder.heightAnchor.constraint(equalToConstant: 350).isActive = true
        cardBorder.widthAnchor.constraint(equalToConstant: 350).isActive = true
    }
    
    lazy var socialMediaImages: [String: UIImageView] = [
        "faceBookProfile": UIManager.makeImage(imageName: "dan_facebook_red"),
        "instagramProfile": UIManager.makeImage(imageName: "dan_instagram_red"),
        "snapChatProfile": UIManager.makeImage(imageName: "dan_snapchat_red"),
        "phoneNumber": UIManager.makeImage(imageName: "dan_phone_red"),
        "linkedin": UIManager.makeImage(imageName: "dan_linkedin_red"),
        "email": UIManager.makeImage(imageName: "dan_email_red"),
        ]
    
    func presentSocialMediaButtons() {
        var spacing: CGFloat = 20
        for (_, image) in socialMediaImages {
            self.addSubview(image)
            image.topAnchor.constraint(equalTo: bioLabel.topAnchor, constant: 20).isActive = true
            image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing).isActive = true
            image.heightAnchor.constraint(equalToConstant: 40).isActive = true
            image.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            spacing += 60
        }
    }
}
