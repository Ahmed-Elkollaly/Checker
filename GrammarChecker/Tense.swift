//
//  Tense.swift
//  GrammarChecker
//
//  Created by Ahmed El-Kollaly on 10/14/17.
//  Copyright © 2017 Ahmed El-Kollaly. All rights reserved.
//

import Foundation

struct Tense {
    struct PresentSimple {
        static let specialEndings = ["o","ch","sh","th","ss","gh","zz","x"]
        static let keywords = ["always","frequently","often","usually","seldom","rarely","nowadays","never"]
        static let irregularVerbs = ["be" : ("am","is","are"),"have":("have","has","have")]
        static let S = "s"
        static let ES = "es"
        static let IES = "ies"
        static let Y = "y"
    }
    struct Past {
        static let verbToBe = ["be":("was","were","been")]
        static let irregularVerbs = ["abide"  :  ("abode" ,   "abode")
            ,"arise"  :  ("arose"  ,  "arisen")
            ,"awake"   : ("awoke",     "awoken")
            ,"bear"  :  ("bore" ,    "born")
            ,"beat"  : ( "beat"   , "beaten")
            ,"become"  :  ("became"  ,  "become")
            ,"befall"  :  ("befell"  ,  "befallen")
            ,"beget"  :  ("begot"  ,  "begotten")
            ,"begin"   : ("began"  ,  "begun")
            ,"behold"   : ("beheld"  ,  "beheld")
            ,"bend"   : ("bent"  ,  "bent")
            ,"bereave"  :  ("bereave"    , "bereft")
            ,"beseech"   : ("besought",    "besought")
            ,"bet"   : ( "bet"  ,  "bet")
            ,"bid" :    ("bade" ,    "bidden")
            ,"bind" :   ("bound"   , "bound")
            ,"bite"  :  ("bit"  ,  "bitten")
            ,"bleed"  : ( "bled"   , "bled")
            ,"blow"    :("blew"  ,  "blown")
            ,"break"    :("broke" ,   "broken")
            ,"breed"    :("bred"  ,  "bred")
            ,"bring"    :("brought",    "brought")
            ,"broadcast" :   ("broadcast",    "broadcast")
            ,"build"    :("built"  ,  "built")
            ,"burn"    : ("burnt"    , "burnt")
            ,"burst"    :("burst"  ,  "burst")
            ,"buy"    :("bought" ,   "bought")
            ,"cast"    :("cast"    ,"cast")
            ,"catch"    :("caught"  ,  "caught")
            ,"chide"    :("chid"    ,"chidden")
            ,"choose"    :("chose"   , "chosen")
            ,"cleave"    :("clove"  ,  "cloven")
            ,"cling"    :("clung"  ,  "clung")
            ,"clothe"    : ("clad"    , "clad")
            ,"come"    :("came"    ,"come")
            ,"cost"    :("cost"    ,"cost")
            ,"creep"    :("crept"  ,  "crept")
            ,"crow"    :("crowed" ,   "crowed")
            ,"cut"    :("cut"    ,"cut")
            ,"dare"    : ("durst"  ,   "durst")
            ,"deal"    :("dealt"  ,  "dealt")
            ,"dig"    :("dug"    ,"dug")
            ,"do"    :("did"    ,"done")
            ,"draw"    :("drew"    ,"drawn")
            ,"dream"   :  ("dreamt"  ,   "dreamt")
            ,"drink"   : ("drank"   , "drunk")
            ,"drive"    :("drove"  ,  "driven")
            ,"dwell"   :  ("dwelt",     "dwelt")
            ,"eat"   : ("ate"    ,"eaten")
            ,"fall"   : ("fell"   , "fallen")
            ,"feed"   : ("fed"    ,"fed")
            ,"feel"   : ("felt"   , "felt")
            ,"fight"   : ("fought"  ,  "fought")
            ,"find"   : ("found"   , "found")
            ,"flee"   : ("fled"    ,"fled")
            ,"fling"  :  ("flung"  ,  "flung")
            ,"fly"    :("flew"    ,"flown")
            ,"forbear" :   ("forbore"   , "forborne")
            ,"forbid"   : ("forbade"   , "forbidden")
            ,"forget"   : ("forgot"    ,"forgotten")
            ,"forgive"   : ("forgave"  ,  "forgiven")
            ,"forsake"   : ("forsook" ,   "forsaken")
            ,"freeze"   : ("froze"   , "frozen")]
    }
}
