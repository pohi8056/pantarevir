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
import Firebase

class ScanReceiptViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    var storeName: String?
    
    let captureSession = AVCaptureSession()
    var captureDevice:AVCaptureDevice?
    var captureLayer:AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.storeName)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCaptureSession()
    }
    
    
    private func showConfirmationPopup(receipt : Receipt){
        //var confirmedAmount = false
        //let semaphore = dispatch_semaphore_create(0)
        captureSession.stopRunning()

        print("IM HERE")
        
        //let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        //let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        
        //dispatch_async(dispatch_get_main_queue()){
        let alertPopup = UIAlertController(title: "Bekräfta pantning", message: "Belopp: \(receipt.amount)0 kr", preferredStyle: UIAlertControllerStyle.Alert)
        let confirmAction = UIAlertAction(title: "Bekräfta", style: UIAlertActionStyle.Default, handler: { Void in
                print("CONFIRMHERE")
                self.checkForPreviousReceiptsInFirebase(receipt)
                //confirmedAmount = true
                //dispatch_semaphore_signal(semaphore)
            })
        let cancelAction = UIAlertAction(title: "Avbryt", style: UIAlertActionStyle.Cancel, handler: { Void in
                print("CANCEL HERE")
                self.captureSession.startRunning()
                //confirmedAmount = false
                //self.captureSession.startRunning()
                //dispatch_semaphore_signal(semaphore)
            })
        //dispatch_async(backgroundQueue, {
        alertPopup.addAction(confirmAction)
        alertPopup.addAction(cancelAction)
        
        print("ASDASDASDASD")
           // }
        //}
        self.presentViewController(alertPopup, animated: true, completion: nil)
            //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)


        print("HERE")
        //return confirmedAmount
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
    /*
    //Check if receipt is already scanned by the user
    private func checkForPreviousReceiptsInFirebase(receipt : Receipt){
        var receiptAlreadyScanned = false
        var receiptScannedByOtherUser = false
        DataService.service.returnUserReceipt(receipt).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots{
                    let receiptEAN = snap.key
                    if receiptEAN == receipt.receiptEAN{
                        //check all receipts.-----------------------------

                        
                        //------------------------------------------------
                        //INSERT TIME CHECK HERE
                        receiptAlreadyScanned = true
                    }
                }
            }
            
            if receiptAlreadyScanned == false{
                DataService.service.addReceipt(receipt)
                self.returnToMainMenu()
            }else{
                self.errorLabel.text = "KVITTO REDAN SKANNAT"
                self.errorLabel.textColor = UIColor.yellowColor()
            }

            
        })
    }
    */
    
    //Convert String to NSDate using the same format as in the receipt
    private func getDateAndTimeFromFirebase(timestamp : String) -> NSDate{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        let date = formatter.dateFromString(timestamp)
        return date!
    }
    
    private func compareDates(time1 : NSDate, time2 : NSDate) -> Int{
        let timeDifference = time1.timeIntervalSinceDate(time2)
        let timeDifferenceInSeconds = Int(timeDifference)
        return timeDifferenceInSeconds
    }
    
    
    private func checkForPreviousReceiptsInFirebase(receipt : Receipt){
        var receiptAlreadyScanned = false
        var receiptScannedByOtherUser = false
        DataService.service.rootRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            /*----------------Check this user.-------------------*/
            if let snapshots = snapshot.childSnapshotForPath("users/\(receipt.userUID)/receipts").children.allObjects as? [FDataSnapshot] {
                for snap in snapshots{
                    let receiptEAN = snap.key
                    if receiptEAN == receipt.receiptEAN{

                        receiptAlreadyScanned = true
                    }
                }
            }
            /*-------------Check all receipts scanned by all users ----------------*/

            if let snapshots = snapshot.childSnapshotForPath("receipts/").children.allObjects as? [FDataSnapshot] {
                for snap in snapshots{
                    let receiptEAN = snap.key
                    if receiptEAN == receipt.receiptEAN{
                        let timeOfOldReceipt = snap.childSnapshotForPath("time").value as! String
                        let timeOfCurrentReceipt = self.getDateAndTimeFromFirebase(receipt.timeStamp)
                        
                        print("Time of that receipt is: \(timeOfOldReceipt)")
                        let timeOfOldReceiptNSDate = self.getDateAndTimeFromFirebase(timeOfOldReceipt)
                        let timeDifference = self.compareDates(timeOfCurrentReceipt, time2: timeOfOldReceiptNSDate)
                        print("Time of old receipt in date format: \(timeOfOldReceiptNSDate)")
                        print("Time of new receipt in date format: \(timeOfCurrentReceipt)")

                        print("Time difference: \(timeDifference)")
                        if timeDifference < 240{
                            receiptScannedByOtherUser = true
                        }
                    }
                }
            }
            /*---------------------------------------------------*/

            
            
            if receiptAlreadyScanned == false && receiptScannedByOtherUser == false{
                DataService.service.addReceipt(receipt)
                self.returnToMainMenu()
            }else{
                print("Scanned by this user: \(receiptAlreadyScanned)")
                print("Scanned by another user within 3 minutes: \(receiptScannedByOtherUser)")
                self.errorLabel.text = "KVITTO REDAN SKANNAT"
                self.errorLabel.textColor = UIColor.yellowColor()
            }
            
            
        })
    }
    
    //Validate the amount and key numbers in the EAN. True if all is ok.
    private func validateReceiptBarcode(barcode : String, type: String) -> Bool{
        let barcodePrefix = barcode.substringToIndex(barcode.startIndex.advancedBy(1))
        let barcodeAmount = barcode.substringWithRange(Range<String.Index>(barcode.startIndex.advancedBy(8)..<barcode.endIndex.advancedBy(-1)))
        let barcodeAmountHigh = barcode.substringWithRange(Range<String.Index>(barcode.startIndex.advancedBy(5)..<barcode.endIndex.advancedBy(-5))) //KAN VARA FEL I VISSA BUTIKER med advanceby(5) då det ibland borde vara 4, fix here if probs.
        let barcode23 = barcode.substringWithRange(Range<String.Index>(barcode.startIndex.advancedBy(2)..<barcode.startIndex.advancedBy(4))) //inte testat

        
        //TODO IMORGON: AMOUNT, OCH KIKA SIFFRA 3 OCH 4 FÖR ATT VALIDERA OM GILTILG BUTIK.
        //print("23!!! \(barcode23)")
        /* ------------Endast en tes om att det är så att om 9 så går det läsa kvitto, needs to be confirmed------------------*/
        print("Checking if store uses reference system...")
        let barcodeReferenceSystem = barcode.substringWithRange(Range<String.Index>(barcode.startIndex.advancedBy(1)..<barcode.startIndex.advancedBy(2)))
        
        if (barcodeReferenceSystem != "9" || barcodeReferenceSystem != "8") && barcode23 != "99"{
            errorLabel.text = "TJÄNST EJ TILLGÄNGLIG I DENNA BUTIK"
            errorLabel.textColor = UIColor.orangeColor()
            print("Not a valid store - Store uses a reference system.")
        }else{
        /*------------------------------------------------------------------------------------------------------*/
            print("Store OK - Does not use reference system.")
            print("Checking initial value...")
            
            if barcodePrefix != "9" || calculateBarcodeChecksum(barcode) != true || validateAmountOfReceipt(barcodeAmount) != true{
                errorLabel.text = "EJ GILTIGT KVITTO SKANNAT"
                errorLabel.textColor = UIColor.redColor()
                print("Not a valid prefix or amount.")
            }else{
                errorLabel.textColor = UIColor.greenColor()
                errorLabel.text = "PANTKVITTO SKANNAT"
                print("Everything ok!")
                
                //inc.
                let amountDoubleLow = Double(barcodeAmount)!/10.0
                let amountDoubleHigh = Double(barcodeAmountHigh)!/10.0
                let amountDouble = amountDoubleLow + amountDoubleHigh
                let currentUser = NSUserDefaults.standardUserDefaults().stringForKey("uid")
                let receipt = Receipt(receiptEAN: barcode, userUID: currentUser!, amount: amountDouble, store: storeName!)

                showConfirmationPopup(receipt)
                //    addAmountToFirebase(amountDouble, EAN: barcode)
                    return true
                
                
            }
        }
        return false
    }
    
    
    //Validate the receipt type. Only the type org.gs1.EAN-13 is used for receipts in Sweden.
    private func validateReceiptType(barcode : String, barcodeType : String) -> Bool{
        print("Validating if barcode is of type EAN-13...")
        if barcodeType == validReceiptType || barcodeType == validReceiptTypeReferenceSystem{
            print("Barcode type OK.")
            if validateReceiptBarcode(barcode, type: barcodeType) == true{
                return true
            }
        }else{
            errorLabel.text = "EJ ETT GILTIGT PANTKVITTO"
            errorLabel.textColor = UIColor.redColor()
            print(barcodeType)
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
    
    func returnToMainMenu(){
        print("Backed from scanner.")
        let menuView = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenu")
        UIApplication.sharedApplication().keyWindow?.rootViewController = menuView
    }
    
    @IBAction func backButton(sender: UIButton) {
        returnToMainMenu()
    }
}