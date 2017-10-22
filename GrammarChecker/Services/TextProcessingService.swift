//
//  TextProcessing.swift
//  GrammarChecker
//
//  Created by Ahmed El-Kollaly on 10/10/17.
//  Copyright © 2017 Ahmed El-Kollaly. All rights reserved.
//

import Foundation

class TextProcessingService  {
    

    static func textProcessing(_ text: String) -> [Word]{
        
        let options : NSLinguisticTagger.Options = [.omitWhitespace,.omitOther]
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"), options: Int(options.rawValue))
        tagger.string = text
        
        var resultTokens:[Word] = []
        tagger.enumerateTags(in: NSMakeRange(0, text.characters.count), scheme: .lexicalClass, options: options){
            (tag,tokenRange,_,_) in
            
            let word = (text as NSString).substring(with: tokenRange)
            if let tag = tag{
                
                resultTokens.append(Word(word,tag.rawValue," "))
            }else {
                resultTokens.append(Word(word," "," "))
            }
            
            
        }
        var index = 0
        tagger.enumerateTags(in: NSMakeRange(0, text.characters.count), scheme: .lemma, options: options){
            (tag,tokenRange,_,_) in
            
            if let tag = tag{
                resultTokens[index].wordBaseForm = tag.rawValue
                index += 1
            }else{
                index += 1
            }
            
            
        }
        return resultTokens
    }

   
}
