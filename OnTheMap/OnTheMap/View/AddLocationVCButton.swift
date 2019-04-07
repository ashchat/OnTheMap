//
//  AddLocationVCButton.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 4/5/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import UIKit

class AddLocationVCButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.udacity.cgColor
        self.layer.borderWidth = 1
    }
    
}
