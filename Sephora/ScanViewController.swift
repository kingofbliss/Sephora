//
//  SecondViewController.swift
//  Sephora
//
//  Created by payoda on 27/04/16.
//  Copyright © 2016 Anand Raj R. All rights reserved.
//

import UIKit
import AVFoundation

var session:AVCaptureSession!

class ScanViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        SDUtils().changeTabBadge(self)
        session = AVCaptureSession()
        captureQRCode()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        session.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Scan"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - QR Scan

    func captureQRCode() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device) as AVCaptureDeviceInput
            session.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            let bounds = self.view.layer.bounds
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer.bounds = bounds
            previewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
            
            self.view.layer.addSublayer(previewLayer)
            session.startRunning()
        } catch let error as NSError {
            SDUtils().showAlertandDismiss(self,message:error.localizedDescription)
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for item in metadataObjects {
            if let metadataObject = item as? AVMetadataMachineReadableCodeObject {
                if metadataObject.type == AVMetadataObjectTypeQRCode {
                    print("QR Code: \(metadataObject.stringValue)")
                    session.stopRunning()
                    self.dismissViewControllerAnimated(false, completion: nil)
                    let productDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("productDetailViewController") as! ProductDetailViewController
                    productDetailVC.productID = Int(metadataObject.stringValue)
                    self.navigationController?.pushViewController(productDetailVC, animated: true)
                }
            }
        }
    }
}

