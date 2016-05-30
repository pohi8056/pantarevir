//
//  SettingsViewController.swift
//  Pantarevir
//
//  Created by Anton Källbom on 23/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var revirColorPicker: UIPickerView!
    
    var colors = ["Röd","Turkos","Gul","Blå","Orange","Rosa","Svart","Grön"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        revirColorPicker.delegate = self
        revirColorPicker.dataSource = self

        // Do any additional setup after loading the view.
        
    }

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    
    func pickerView(
        pickerView: UIPickerView,
        didSelectRow row: Int,
                     inComponent component: Int)
    {

        let selectedColorRow = colors[row]
        
        
        print(selectedColorRow)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: UIButton) {
        let menuView = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenu")
        UIApplication.sharedApplication().keyWindow?.rootViewController = menuView
    }

    
    
 

}
