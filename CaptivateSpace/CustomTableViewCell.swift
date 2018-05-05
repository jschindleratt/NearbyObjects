//
//  CustomTableViewCell.swift
//  CaptivateSpace
//
//  Created by Joshua Schindler on 5/1/18.
//  Copyright © 2018 Joshua Schindler. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var delegate:OptionButtonsDelegate!
    @IBOutlet weak var favoriteBtn: UIButton!
    var indexPath:IndexPath!
    @IBAction func favoriteAction(_ sender: UIImageView) {
        self.delegate?.favoriteTapped(at: indexPath)
    }
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
}
protocol OptionButtonsDelegate{
    func favoriteTapped(at index:IndexPath)
}
