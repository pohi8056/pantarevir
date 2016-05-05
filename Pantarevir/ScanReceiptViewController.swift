//
//  ScanReceiptViewController.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 26/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//  sitepoint.com/creating-barcode-metadata-reader-ios/
//

import UIKit
import AVFoundation

class ScanReceiptViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    let captureSession = AVCaptureSession()
    var captureDevice:AVCaptureDevice?
    var captureLayer:AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCaptureSession()
    }
    
    
    private func showConfirmationPopup(amount : Double) -> Bool{
        let alertPopup = UIAlertController(title: "Bekräfta pantning", message: "Belopp: \(amount)0 kr", preferredStyle: UIAlertControllerStyle.Alert)
        alertPopup.addAction(UIAlertAction(title: "Bekräfta", style: UIAlertActionStyle.Default, handler: nil))
        alertPopup.addAction(UIAlertAction(title: "Avbryt", style: UIAlertActionStyle.Default, handler: nil))
        
        
        
        self.presentViewController(alertPopup, animated: true, completion: nil)
        return true
    }
    
    
    //Calculates and validates the barcode checksum https://en.wikipedia.org/wiki/International_Article_Number_(EAN)
    private func calculateBarcodeChecksum(barcode : String) -> Bool{
        print("Validating barcode checksum...")
        
        var barcodeInts = [Int]()
        for index in barcode.characters {
            let character = String(index)
            if let convertedInteger = Int(character){
                barcodeInts = barcodeInts + [convertedInteger]
            }
        }
        //The checksum shown on the receipt
        let barcodeChecksum = barcodeInts[barcodeInts.startIndex.advancedBy(barcodeInts.count-1)]
        var actualChecksum = 0
        print("Barcode in integers: ")
        print(barcodeInts)
        
        //Multiplies all even indicies by 1 and all odd by 3, then sums them.
        for index in 0...barcodeInts.count-2{
            if index%2 == 0{
                barcodeInts[index] = barcodeInts[index]*1
            }else if index%2 == 1{
                barcodeInts[index] = barcodeInts[index]*3
            }else{
                print("MAJOR ERROR, not possible...?")
            }
            actualChecksum = actualChecksum + barcodeInts[index]
        }
        
        var closestNumberToActualChecksum = 0
       
        //Checks for the greatest closest modulus 10 number.
        for i in 1...10{
            if ((actualChecksum+i) % 10) == 0{
                closestNumberToActualChecksum = actualChecksum+i
            }
        }
        actualChecksum = closestNumberToActualChecksum - actualChecksum
        
        print("Actual checksum: \(actualChecksum)")
        print("Barcode checksum: \(barcodeChecksum)")

        
        if actualChecksum == barcodeChecksum{
            print("OK. Checksums matches.")
            return true
        }else{
            print("Photoshopped receipt.")
            return false
        }
    }
    
    
    //Convert the string amount to Double and check if reasonable.
     private func validateAmountOfReceipt(receiptAmount : String) -> Bool{
        print("Validating amount of receipt...")
        let amountDouble = Double(receiptAmount)!/10.0
        
        if amountDouble < 0.0 || amountDouble > 1000.0{
            print("The amount \(amountDouble) is unreasonable")
            return false
        }else{
            print("Amount OK.")
            return true
        }
    }
 
    //note to self: Glöm inte kolla om ean redan finns
    
    
    //Add the recycled amount to Firebase
    private func addAmountToFirebase(amount : Double, EAN : String){
        
        let currentUser = NSUserDefaults.standardUserDefaults().stringForKey("uid")
        print(currentUser)
        let receipt = Receipt(receiptEAN: EAN, userUID: currentUser!, amount: amount)
        //print(receipt.returnReceipt())
        DataService.service.addReceipt(receipt)
    }
    
    //Validate the amount and key numbers in the EAN. True if all is ok.
    private func validateReceiptBarcode(barcode : String) -> Bool{
        let barcodePrefix = barcode.substringToIndex(barcode.startIndex.advancedBy(1))
        let barcodeAmount = barcode.substringWithRange(Range<String.Index>(barcode.startIndex.advancedBy(8)..<barcode.endIndex.advancedBy(-1)))
        let barcode23 = barcode.substringWithRange(Range<String.Index>(barcode.startIndex.advancedBy(2)..<barcode.startIndex.advancedBy(4))) //inte testat

        
        //TODO IMORGON: AMOUNT, OCH KIKA SIFFRA 3 OCH 4 FÖR ATT VALIDERA OM GILTILG BUTIK.
        //print("23!!! \(barcode23)")
        /* ------------Endast en tes om att det är så att om 9 så går det läsa kvitto, needs to be confirmed------------------*/
        print("Checking if store uses reference system...")
        let barcodeReferenceSystem = barcode.substringWithRange(Range<String.Index>(barcode.startIndex.advancedBy(1)..<barcode.startIndex.advancedBy(2)))
        
        if (barcodeReferenceSystem != "9" || barcodeReferenceSystem != "8") && barcode23 != "99"{
            errorLabel.text = "Tjänst ej tillgänglig i denna butik."
            errorLabel.textColor = UIColor.orangeColor()
            print("Not a valid store - Store uses a reference system.")
        }else{
        /*------------------------------------------------------------------------------------------------------*/
            print("Store OK - Does not use reference system.")
            print("Checking initial value...")
            
            if barcodePrefix != "9" || calculateBarcodeChecksum(barcode) != true || validateAmountOfReceipt(barcodeAmount) != true{
                errorLabel.text = "Ej giltligt kvitto scannat."
                errorLabel.textColor = UIColor.redColor()
                print("Not a valid prefix or amount.")
            }else{
                errorLabel.textColor = UIColor.greenColor()
                errorLabel.text = "Pantkvitto OK."
                print("Everything ok!")
                
                //Fullösning inc.
                let amountDouble = Double(barcodeAmount)!/10.0
                if showConfirmationPopup(amountDouble) == true{
                    addAmountToFirebase(amountDouble, EAN: barcode)
                    return true
                }
                
            }
        }
        return false
    }
    
    
    //Validate the receipt type. Only the type org.gs1.EAN-13 is used for receipts in Sweden.
    private func validateReceiptType(barcode : String, barcodeType : String) -> Bool{
        print("Validating if barcode is of type EAN-13...")
        if barcodeType == validReceiptType{
            print("Barcode type OK.")
            if validateReceiptBarcode(barcode) == true{
                return true
            }
        }else{
            errorLabel.text = "Inte ett giltligt pantkvitto"
            errorLabel.textColor = UIColor.redColor()
            print("Not a valid barcode type.")
        }
        return false
    }
    
    
    
    private func setupCaptureSession(){
        self.captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let deviceInput:AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(deviceInput)){
            // Show live feed
            captureSession.addInput(deviceInput)
            self.setupPreviewLayer({
                self.captureSession.startRunning()
                self.addMetaDataCaptureOutToSession()
            })
        } else {
            self.showError("Error while setting up input captureSession.")
        }
    }
    

    private func setupPreviewLayer(completion:() -> ())
    {
        self.captureLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let capLayer = self.captureLayer {
            capLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            capLayer.frame = self.cameraView.frame
            self.view.layer.addSublayer(capLayer)
            completion()
        } else {
            self.showError("An error occured beginning video capture")
        }
    }
    

    private func addMetaDataCaptureOutToSession()
    {
        let metadata = AVCaptureMetadataOutput()
        self.captureSession.addOutput(metadata)
        metadata.metadataObjectTypes = metadata.availableMetadataObjectTypes
        metadata.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        for metadata in metadataObjects{
            let decodedData:AVMetadataMachineReadableCodeObject = metadata as! AVMetadataMachineReadableCodeObject
            //self.errorLabel.text = decodedData.stringValue
            //self.lblDataType.text = decodedData.type
            
            if validateReceiptType(decodedData.stringValue, barcodeType: decodedData.type) == true{
                //koden om bra kvitto
            }
        }
    }
    


    private func showError(error:String)
    {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        let dismiss:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Destructive, handler:{(alert:UIAlertAction) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(dismiss)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func backButton(sender: UIButton) {
        print("Backed from scanner.")
        let menuView = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenu")
        UIApplication.sharedApplication().keyWindow?.rootViewController = menuView
    
    }
    
}