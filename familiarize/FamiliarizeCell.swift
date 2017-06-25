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


class FamiliarizeCell: BaseCell {
    var onQRImage: Bool = true
    
    
    func createJSON() -> String {
        let qrJSON: JSON = [
            "name": "Alex Oh",
            "fb": "alexswoh",
            "ig": "alexswo",
            "sc": "alexoooh",
            "pn": "2136041187",
            "bio": "Software Engineer",
            ]
        return qrJSON.rawString()!
    }
    
    lazy var qrImageView: UIImageView = {
        var qrCode = QRCode(self.createJSON())
        qrCode?.color = CIColor.white()
        qrCode?.backgroundColor = CIColor(red:1.00, green: 0.52, blue: 0.52, alpha: 1.0)
        let imageView = UIImageView()
        imageView.image = qrCode?.image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cardBorder: UIImageView = {
        let image = UIManager.makeImage(imageName: "dan_card_border")
        image.tag = 1
        return image
    }()
    
    let bioLabel: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        return label
        
    }()
    
    func flip() {
        
        for v in (self.subviews){
            if v.tag != 1 {
                v.removeFromSuperview()
            }
        }
        if onQRImage == true {
            addSubview(bioLabel)
            
            let bio = NSMutableAttributedString(string: "Palo Alto, 29, Coffee Enthusiast", attributes: [NSFontAttributeName: UIFont(name: "Avenir", size: 20)!, NSForegroundColorAttributeName: UIColor(red:1.00, green: 0.52, blue: 0.52, alpha: 1.0)])
            
            bioLabel.attributedText = bio
            
            bioLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            bioLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30).isActive = true
            bioLabel.heightAnchor.constraint(equalToConstant: bioLabel.intrinsicContentSize.height).isActive = true
            bioLabel.widthAnchor.constraint(equalToConstant:bioLabel.intrinsicContentSize.width).isActive = true
            presentSocialMediaButtons()
            
            onQRImage = false
        } else {
            addSubview(qrImageView)
            qrImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            qrImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50).isActive = true
            qrImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            qrImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
            onQRImage = true
        }
    }
    
    override func setupViews() {
        addSubview(cardBorder)
        addSubview(qrImageView)
        qrImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        qrImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50).isActive = true
        qrImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        qrImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
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
        var xSpacing: CGFloat = 50
        var ySpacing: CGFloat = 10
    
        var size = socialMediaImages.count
        var count = 0
        size = 3
        
        if size == 1 {
            for (_, image) in socialMediaImages {
                self.addSubview(image)
                image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: ySpacing).isActive = true
                image.heightAnchor.constraint(equalToConstant: 65).isActive = true
                image.widthAnchor.constraint(equalToConstant: 65).isActive = true

                count += 1
                if count == 1{
                    break
                }
            }
        } else if size == 2 {
            for (_, image) in socialMediaImages {
                self.addSubview(image)
                image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xSpacing).isActive = true
                image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: ySpacing).isActive = true
                image.heightAnchor.constraint(equalToConstant: 65).isActive = true
                image.widthAnchor.constraint(equalToConstant: 65).isActive = true

                xSpacing = xSpacing * (-1)
                count += 1
                if count == 2{
                    break
                }
            }
        } else if size == 3 {
            ySpacing = 20
            for (_, image) in socialMediaImages {
                if count < 2 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xSpacing).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: -ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                    xSpacing = xSpacing * (-1)
                }
                else if count == 2 {
                    self.addSubview(image)
                    image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                    image.centerYAnchor.constraint(equalTo: self.cardBorder.centerYAnchor, constant: 3*ySpacing).isActive = true
                    image.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    image.widthAnchor.constraint(equalToConstant: 60).isActive = true
                }

                count += 1
                if count == 3{
                    break
                }
            }
        } else if size == 4 {
            for (_, image) in socialMediaImages {
                self.addSubview(image)
                image.topAnchor.constraint(equalTo: bioLabel.topAnchor, constant: 20).isActive = true
                image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: xSpacing).isActive = true
                image.heightAnchor.constraint(equalToConstant: 40).isActive = true
                image.widthAnchor.constraint(equalToConstant: 40).isActive = true
                
                xSpacing += 60
                count += 1
                if count == 4{
                    break
                }
            }
        } else if size == 5 {
            for (_, image) in socialMediaImages {
                self.addSubview(image)
                image.topAnchor.constraint(equalTo: bioLabel.topAnchor, constant: 20).isActive = true
                image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: xSpacing).isActive = true
                image.heightAnchor.constraint(equalToConstant: 40).isActive = true
                image.widthAnchor.constraint(equalToConstant: 40).isActive = true
                
                xSpacing += 60
                
                count += 1
                if count == 5{
                    break
                }
            }
        } else if size == 6 {
            for (_, image) in socialMediaImages {
                self.addSubview(image)
                image.topAnchor.constraint(equalTo: bioLabel.topAnchor, constant: 20).isActive = true
                image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: xSpacing).isActive = true
                image.heightAnchor.constraint(equalToConstant: 40).isActive = true
                image.widthAnchor.constraint(equalToConstant: 40).isActive = true
                
                xSpacing += 60
                count += 1
                if count == 6{
                    break
                }
            }
        }
        else {
            for (_, image) in socialMediaImages {
                self.addSubview(image)
                image.topAnchor.constraint(equalTo: bioLabel.topAnchor, constant: 20).isActive = true
                image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: xSpacing).isActive = true
                image.heightAnchor.constraint(equalToConstant: 40).isActive = true
                image.widthAnchor.constraint(equalToConstant: 40).isActive = true
                
                xSpacing += 60
                count += 1
                if count == 6{
                    break
                }
            }
        }
        
        
        

    }
}
