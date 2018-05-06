//
//  PreferencesViewController.swift
//  CaptivateSpace
//
//  Created by Joshua Schindler on 4/28/18.
//  Copyright © 2018 Joshua Schindler. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {

    @IBOutlet weak var lblLunarLengths: UILabel!
    @IBOutlet weak var lblYears: UILabel!
    @IBOutlet weak var sldLunarLengths: UISlider!
    @IBOutlet weak var sldYears: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lunarDistances: Float = UserDefaults.standard.float(forKey: "lunarDistances")
        lblLunarLengths.text = lunarDistances.description
        sldLunarLengths.setValue(Float(lunarDistances), animated: true)
        let numberOfYears: Float = UserDefaults.standard.float(forKey: "numberOfYears")
        lblYears.text = numberOfYears.description
        sldYears.setValue(Float(numberOfYears), animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        var key:String = "lunarDistances"
        var label:UILabel = lblLunarLengths
        if (sender == sldYears) {
            key = "numberOfYears"
            label = lblYears
        }
        let currentValue = Float(sender.value)
        label.text = "\(currentValue)"
        UserDefaults.standard.set(currentValue, forKey: key)
    }
}
