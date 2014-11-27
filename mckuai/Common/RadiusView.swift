//
//  RadiusView.swift
//  smartmixer
//
//  Created by Koulin Yuan on 8/23/14.
//  Copyright (c) 2014 Smart Group. All rights reserved.
//

import UIKit

@IBDesignable class RadiusView : UIView {
    
    @IBInspectable var borderColor:UIColor = UIColor.grayColor(){
        didSet{
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 1 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var cornerRadius:CGFloat = 10 {
        didSet{
            clipsToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
}
