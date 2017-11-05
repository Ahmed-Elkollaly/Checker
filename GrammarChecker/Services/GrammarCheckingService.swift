//
//  GrammarCheckingService.swift
//  GrammarChecker
//
//  Created by Ahmed El-Kollaly on 10/10/17.
//  Copyright © 2017 Ahmed El-Kollaly. All rights reserved.
//

import Foundation
import UIKit
class GrammarCheckingService {
    
    static let shared =  GrammarCheckingService()
    enum WordType { case singular,plural,I,none,verb,modalVerb,preposition,particle}
    
    enum VerbTense {
        case present,pastRegular,pastSimpleIrregular,pastParticipleIrregular,pastIrregular,continuous
    }
    /**
     Mark :-  Get Present Tense of Verb
     **/
     func presentTense(_ type:WordType,_ word:Word) -> Word{
        
        var result = word
        if let verb = Tense.PresentSimple.irregularVerbs[word.wordBaseForm] {
            switch type {
            case .I:
                result.word = verb.0
                
            case .singular:
                result.word = verb.1
                
            case .plural:
                result.word = verb.2
                
            default: break
                
            }
            
        }else {
            switch type {
            case .singular:
                result.word = word.wordBaseForm
                let lastChar = String(result.word.suffix(1))
                let lastTwoChars = String(result.word.suffix(2))
                if Tense.PresentSimple.specialEndings.contains(lastChar) ||
                    Tense.PresentSimple.specialEndings.contains(lastTwoChars){
                    result.word += Tense.PresentSimple.ES
                }else{
                    
                    
                    let beforeLastCh = result.word[result.word.index(result.word.endIndex, offsetBy: -2)]
                    //Check if last char is 'y' and before last is constant then remove 'y' and add 'ies' ex. cry ==> cries
                    if lastChar == Tense.PresentSimple.Y && !EnglishConstants.vowels.contains(String(beforeLastCh)) {
                        result.word.remove(at: result.word.index(result.word.endIndex, offsetBy: -1))
                        result.word += Tense.PresentSimple.IES
                    }else{
                        //if regular verb with no special endings just add S
                        result.word += Tense.PresentSimple.S
                    }
                }
                
            case .I,.plural:
                result.word = word.wordBaseForm
            default:
                break;
            }
        }
        
        
        return result
    }
     func grammarChecking(_ words:[Word]) -> (String,String,[Word]){
        var prevWord:Word = Word(" ", " ", " ")
        var results :[Word] = []
        var errors:[Word] = []
        
        for (index,w) in words.enumerated() {
            print("\(w.word) \(w.tag) \(w.wordBaseForm)")
            
            if w.wordBaseForm == " "{
                var s = w
                s.textColor = UIColor.red
                results.append(s)
                errors.append(s)
            }else if w.tag == "Verb" && !EnglishConstants.modalVerbs.contains(w.word.lowercased()) {
                let prevToken = identifyFirstNounOrVerbOrPronoun(index, results)
                let type = prevToken.0
                print("TYEPE = \(type)")
                //Rule 1 : I , plural ,singular
                if [WordType.I,WordType.plural,WordType.singular].contains(type){
                    let lastTwoChs = String(w.word.suffix(2))
                    //Rule 2 : regular past simple verb
                    if lastTwoChs == "ed" && w.word != w.wordBaseForm   {
                        results.append(w)
                    }else if let verb = Tense.Past.irregularVerbs[w.wordBaseForm], verb.1 == w.word.lowercased() || verb.0 == w.word.lowercased(), w.word.lowercased() != w.wordBaseForm{
                        //Rule 3: pp verb
                        if verb.1 == w.word.lowercased(){
                            
                            errors.append(w)
                        }
                        results.append(Word(verb.0,"Verb",w.wordBaseForm))
                    } else if let be = Tense.Past.verbToBe[w.wordBaseForm], !["am","is","are","be","'m"].contains(w.word.lowercased()) {
                        //Rule 4: was were
                        if type == .singular || type == .I {
                            if be.1 == w.word  || be.2 == w.word{
                                results.append(Word(be.0,"Verb",w.wordBaseForm))
                                errors.append(w)
                            }else{
                                results.append(w)
                            }
                        }else if type == .plural {
                            if be.0 == w.word.lowercased()  || be.2 == w.word.lowercased(){
                                results.append(Word(be.1,"Verb",w.wordBaseForm))
                                errors.append(w)
                            }else{
                                results.append(w)
                            }
                        }
                    }else {
                        var presentVerb = Word(" "," "," ")
                        
                        presentVerb = self.presentTense(type, w)
                        
                        
                        if presentVerb.word == w.word {
                            
                            results.append(presentVerb)
                        }else{
                            
                            results.append(presentVerb)
                            errors.append(presentVerb)
                        }
                    }
                    
                }else if type == .particle {
                    let r = self.presentTense(.plural, w)
                    results.append(r)
                }else if type == .modalVerb {
                    if w.word == w.wordBaseForm {
                        results.append(w)
                    }else{
                        results.append(Word(w.wordBaseForm,"Verb",w.wordBaseForm))
                            errors.append(w)
                    }
                }else if type == .verb {
//                    let verbTense = getVerbTense(w)
//                    var resultWord:Word?
//                    if prevToken.1 == "be" {
//                        if prevToken.1.word.lowercase() == "being" {
//                            resultWord = presentTense(w)
//                        }
//                    }
                    results.append(w)
                } else{
                    results.append(w)
                }
                
            }else{
                results.append(w)
            }
            
            prevWord = w
        }
        //print("Sentence: ")
        var sentence = "",correctedSentence = ""
        for w in words {
            sentence += w.word
            sentence += " "
        }
        print(sentence)
        
        print("Correction: ")
        for r in results {
            correctedSentence += r.word
            correctedSentence += " "
        }
        print(correctedSentence)
        
        print("Errors: ")
        var line = ""
        for r in errors {
            line += r.word
            line += " "
        }
        print(line)
        
        return (sentence,correctedSentence,errors)
    }
    
    func identifyFirstNounOrVerbOrPronoun(_ end:Int,_ words:[Word]) -> (WordType,Word,Int){
        let subWords = words[..<end]
        var type : WordType = .none
        var indexWord = -1
        var word:Word = Word(" "," "," ")
        var prevWord:Word = Word(" "," "," ")
        for (index,currentWord) in subWords.enumerated() {
            if currentWord.tag == "Pronoun" && currentWord.word.lowercased() == currentWord.wordBaseForm.lowercased() {
                if prevWord.word.lowercased() == "and" || EnglishConstants.pluralSubjectPronouns.contains(currentWord.word.lowercased()) {
                    type = .plural
                    indexWord = index
                    word = currentWord
                    
                }else if EnglishConstants.I == currentWord.word{
                    type = .I
                    indexWord = index
                    word = currentWord
                }else if EnglishConstants.singularSubjectPronouns.contains(currentWord.word.lowercased()){
                    type = .singular
                    indexWord = index
                    word = currentWord
                }
                
            }else if currentWord.tag == "Noun" && !["Particle","Preposition"].contains(prevWord.tag) {
                print(prevWord)
                if currentWord.word.lowercased() == currentWord.wordBaseForm {
                    type = .singular
                    indexWord = index
                    word = currentWord
                }else{
                    type = .plural
                    indexWord = index
                    word = currentWord
                }
            }else if currentWord.tag == "Verb" {
                if EnglishConstants.modalVerbs.contains(currentWord.word.lowercased()){
                    type = .modalVerb
                    indexWord = index
                    word = currentWord
                }else{
                    type = .verb
                    indexWord = index
                    word = currentWord
                }
            }else if currentWord.tag == "Particle" {
                type = .particle
                indexWord = index
                word = currentWord
            }
            prevWord = currentWord
            
        }
        return (type,word,indexWord)
    }
     func verbContinuousForm(_ word: Word) -> Word{
        var result = word.wordBaseForm
        var secondCharBeforeLast = " "
        if result.characters.count > 2 {
            secondCharBeforeLast = String(result[result.index(result.endIndex, offsetBy: -3)])
        }
        let beforeLastCh = String(result[result.index(result.endIndex, offsetBy: -2)])
        //Check if last char is 'y' and before last is constant then remove 'y' and add 'ies' ex. cry ==> cries
        let lastChar = String(result[result.index(result.endIndex, offsetBy: -1)])
        if lastChar == "e" {
            if beforeLastCh == "i"{
                result.remove(at: result.index(result.endIndex, offsetBy: -1))
                result.remove(at: result.index(result.endIndex, offsetBy: -1))
                result += "y"
            }else{
                result.remove(at: result.index(result.endIndex, offsetBy: -1))
            }
            
            result += "ing"
        }else if !EnglishConstants.vowels.contains(lastChar) && EnglishConstants.vowels.contains(beforeLastCh) && !EnglishConstants.vowels.contains(secondCharBeforeLast){
            result += "\(lastChar)ing"
        }else{
            //if regular verb with no special endings just add S
            result += "ing"
        }
        var resultWord = word
        resultWord.word = result
        return resultWord
    }
     func regularVerbPastForm(_ word:Word) -> Word {
        var result = word.wordBaseForm
        var secondCharBeforeLast = " "
        if result.characters.count > 2 {
            secondCharBeforeLast = String(result[result.index(result.endIndex, offsetBy: -3)])
        }
        let beforeLastCh = String(result[result.index(result.endIndex, offsetBy: -2)])
        //Check if last char is 'y' and before last is constant then remove 'y' and add 'ies' ex. cry ==> cries
        let lastChar = String(result[result.index(result.endIndex, offsetBy: -1)])
        if lastChar == Tense.PresentSimple.Y && !EnglishConstants.vowels.contains(beforeLastCh) {
            result.remove(at: result.index(result.endIndex, offsetBy: -1))
            result += "ied"
        }else if lastChar == "e" {
            result += "d"
        }else if !EnglishConstants.vowels.contains(lastChar) && EnglishConstants.vowels.contains(beforeLastCh) && !EnglishConstants.vowels.contains(secondCharBeforeLast){
            result += "\(lastChar)ed"
        }else{
            //if regular verb with no special endings just add S
            result += "ed"
        }
        var resultWord = word
        resultWord.word = result
        return resultWord
    }
     func getVerbTense(_ word:Word) -> VerbTense {
        
        var type :VerbTense = .present
        
        let lastTwoChars = String(word.word.suffix(2))
        let lastThreeChars = String(word.word.suffix(3))
        
        if word.word != word.wordBaseForm  {
            if lastThreeChars == "ing" {
                type = .continuous
            }else if let w = Tense.Past.irregularVerbs[word.wordBaseForm]{
                if word.word == w.0 && w.0 == w.1 {
                    type = .pastIrregular
                }else if word.word == w.0 {
                    type = .pastSimpleIrregular
                }else if word.word == w.1 {
                    type =  .pastParticipleIrregular
                }else if lastTwoChars == "ed" {
                    type = .pastRegular
                }
            }else if lastTwoChars == "ed" {
                type = .pastRegular
            }
            
            
        }
        return type
    }
}
