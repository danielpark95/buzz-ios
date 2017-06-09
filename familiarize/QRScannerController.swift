//
//  QRScannerController.swift
//  familiarize
//
//  Created by Alex Oh on 6/2/17.
//  Copyright © 2017 nosleep. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire
import Kanna

protocol QRScannerControllerDelegate {
    func commenceCameraScanning()
}

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, QRScannerControllerDelegate {
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var qrJSON: JSON = []
    var cameraActive: Bool = true
    
    let supportedCodeTypes = [AVMetadataObjectTypeQRCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            setupViews()
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }

    
    lazy var backButton: UIButton = {
        let image = UIImage(named: "delete-button") as UIImage?
        var button = UIButton(type: .custom) as UIButton
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectDelete), for: .touchUpInside)
        return button
    }()
    
    func didSelectDelete() {
        self.dismiss(animated: false)
    }
    
    func setupViews() {
        view.addSubview(backButton)
        view.bringSubview(toFront: backButton)
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func setAndVerifyQRJSON(_ qrCode: String) -> Bool {
        // TODO: Before even moving on, this function should verify that the qr code's JSON is in the format that we need it in.
        
        let data = qrCode.data(using: .utf8)
        self.qrJSON = JSON(data!)
        return true
    
    }

    func commenceCameraScanning() {
        self.visualEffectView.removeFromSuperview()
        self.cameraActive = true
    }
    
    lazy var visualEffectView: UIVisualEffectView = {
        var visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffect.frame = self.view.bounds
        return visualEffect
    }()
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) && self.cameraActive == true {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if (metadataObj.stringValue != nil  && setAndVerifyQRJSON(metadataObj.stringValue)) {
                
                view.addSubview(self.visualEffectView)
                // Setting up the controller and animations
                let popupController = PopupController()
                popupController.qrJSON = self.qrJSON
                popupController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                popupController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                popupController.QRScannerDelegate = self
                
                self.scrapeSocialMedia(popupController)
                
                self.present(popupController, animated: true, completion: {
                    popupController.setupGraphics()
                })
                self.cameraActive = false
                
            }
        }
    }
    
    func scrapeSocialMedia(_ popupController: PopupController) {
        // TODO: If user does not have a facebook profile, then try to scrape it from instagram.
        
        Alamofire.request("https://www.facebook.com/" + self.qrJSON["fb"].string!).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html, popupController: popupController)
            }
        }
    }
    
    func parseHTML(html: String, popupController: PopupController) {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            for show in doc.css("img[class^='profilePic img']") {
                let url = NSURL(string: show["src"]!)!
                let data:NSData? = NSData(contentsOf: url as URL)
                popupController.profileImage.image = UIImage(data : data! as Data)!
                popupController.profileImage.clipsToBounds = true
            }
        }
    }

}
