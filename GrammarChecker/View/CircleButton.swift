//
//  CircleButton.swift
//  GrammarChecker
//
//  Created by Ahmed El-Kollaly on 10/17/17.
//  Copyright © 2017 Ahmed El-Kollaly. All rights reserved.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var cornerRadius: CGFloat = 30.0 {
        didSet{
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = cornerRadius
    }

}
