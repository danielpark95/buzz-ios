//
//  ProfileImageSelectionController.swift
//  familiarize
//
//  Created by Alex Oh on 7/11/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Foundation
import UPCarouselFlowLayout
import Alamofire

class SocialMediaProfileImage: SocialMedia {
    var profileImage: UIImage?
    
    init(copyFrom: SocialMedia, withImage profileImage: UIImage) {
        super.init(copyFrom: copyFrom)
        self.profileImage = profileImage
    }
}

class LoadingProfileImageSelectionController: UIViewController {

    var socialMediaInputs: [SocialMedia]?
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        fetchImage()
    }
    
    lazy var activityIndicator1: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 770, height: 770)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor(red: 121/255, green: 221/255, blue: 255/255, alpha: 1.0)
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    lazy var activityIndicator2: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 767, height: 767)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor(red: 121/255, green: 221/255, blue: 255/255, alpha: 1.0)
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    lazy var activityIndicator3: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 764, height: 764)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor(red: 121/255, green: 221/255, blue: 255/255, alpha: 1.0)
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    lazy var activityIndicator4: NVActivityIndicatorView = {
        let aiFrame = CGRect(x: self.view.frame.width/2, y: self.view.frame.width/2, width: 761, height: 761)
        let aiType = NVActivityIndicatorType.ballScaleRipple
        let aiColor = UIColor(red: 121/255, green: 221/255, blue: 255/255, alpha: 1.0)
        let aiPadding = CGFloat(0)
        let actIndicator = NVActivityIndicatorView(frame: aiFrame, type: aiType, color: aiColor, padding: aiPadding)
        actIndicator.startAnimating()
        actIndicator.layer.speed = 0.3
        return actIndicator
    }()
    
    let loadingName: UILabel = {
        let label = UIManager.makeLabel(numberOfLines: 1)
        label.text = "Fetching profile images (:"
        return label
    }()
    
    let skipButton: UIButton = {
       return UIManager.makeButton(imageName: "dan_close_text")
    }()
    
    
    func setupViews() {
        view.addSubview(activityIndicator1)
        activityIndicator1.center.x = view.center.x
        activityIndicator1.center.y = view.center.y
        view.addSubview(activityIndicator2)
        activityIndicator2.center.x = view.center.x
        activityIndicator2.center.y = view.center.y
        view.addSubview(activityIndicator3)
        activityIndicator3.center.x = view.center.x
        activityIndicator3.center.y = view.center.y
        view.addSubview(activityIndicator4)
        activityIndicator4.center.x = view.center.x
        activityIndicator4.center.y = view.center.y

        view.addSubview(loadingName)
        loadingName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingName.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingName.widthAnchor.constraint(equalToConstant: loadingName.intrinsicContentSize.width).isActive = true
        loadingName.heightAnchor.constraint(equalToConstant: loadingName.intrinsicContentSize.height).isActive = true
        
        
        view.addSubview(self.skipButton)
        skipButton.addTarget(self, action: #selector(skipButtonClicked), for: .touchUpInside)
        skipButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 81).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    

    func skipButtonClicked() {
        
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach {
                $0.cancel()
            }
            uploadTasks.forEach {
                $0.cancel()
            }
            downloadTasks.forEach {
                $0.cancel()
            }
        }
        
        URLSession.shared.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            
            dataTasks.forEach {
                $0.cancel()
            }
            uploadTasks.forEach {
                $0.cancel()
            }
            downloadTasks.forEach {
                $0.cancel()
            }
        }
    }
    
    func segueToProfileImageSelectionController(_ socialMediaProfileImages: [SocialMediaProfileImage]) {
        var socialMediaProfileImagesCopy = socialMediaProfileImages
        let defaultSocialMediaInput : SocialMedia = SocialMedia(withAppName: "default", withImageName: "default", withInputName: "default", withAlreadySet: false)
        let defaultSocialMediaProfileImage = SocialMediaProfileImage(copyFrom: defaultSocialMediaInput, withImage: UIImage(named: "default")!)
        socialMediaProfileImagesCopy.append(defaultSocialMediaProfileImage)
        
        let profileImageSelectionController = ProfileImageSelectionController(collectionViewLayout: UPCarouselFlowLayout())
        profileImageSelectionController.socialMediaProfileImages = socialMediaProfileImagesCopy
        profileImageSelectionController.socialMediaInputs = self.socialMediaInputs
        self.navigationController?.pushViewController(profileImageSelectionController, animated: false)
    }
    
    func fetchImage() {
        let massagedSocialMediaInputs = ImageFetchingManager.massageSocialMediaInputsData(socialMediaInputs!)
        
        // If there are no images to find, then do not animate.
        if massagedSocialMediaInputs.count == 0 {
            segueToProfileImageSelectionController([])
        } else {
            setupViews()
            ImageFetchingManager.fetchImages(withSocialMediaInputs: massagedSocialMediaInputs, completionHandler: { fetchedSocialMediaProfileImages in
                self.segueToProfileImageSelectionController(fetchedSocialMediaProfileImages)
            })
        }
    }
    
    
}


