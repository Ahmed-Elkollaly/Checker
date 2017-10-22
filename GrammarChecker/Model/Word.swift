//
//  Word.swift
//  GrammarChecker
//
//  Created by Ahmed El-Kollaly on 10/11/17.
//  Copyright © 2017 Ahmed El-Kollaly. All rights reserved.
//

import Foundation
import UIKit
struct Word {
    var word:String = ""
    var tag:String = ""
    var wordBaseForm:String = ""
    var textColor = UIColor.black
    
    init(_ word:String,_ tag:String,_ wordBaseForm:String) {
        self.word = word
        self.tag = tag
        self.wordBaseForm  = wordBaseForm
    }
    
    
    
}
