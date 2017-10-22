//
//  RoundButton.swift
//  GrammarChecker
//
//  Created by Ahmed El-Kollaly on 10/17/17.
//  Copyright © 2017 Ahmed El-Kollaly. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundButton: UIButton {
    
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
