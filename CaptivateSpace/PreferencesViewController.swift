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
    
    @IBAction func sliderValueChangedYears(_ sender: UISlider) {
        let currentValue = Float(sender.value)
        lblYears.text = "\(currentValue)"
        UserDefaults.standard.set(currentValue, forKey: "numberOfYears")
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Float(sender.value)
        lblLunarLengths.text = "\(currentValue)"
        UserDefaults.standard.set(currentValue, forKey: "lunarDistances")
    }
}
