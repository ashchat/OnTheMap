//
//  LoginVCButton.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/20/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import UIKit

class LoginVCButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        backgroundColor = UIColor.udacity
        tintColor = UIColor.white
    }
    
}
