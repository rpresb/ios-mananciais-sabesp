//
//  Manancial.swift
//  ios-mananciais-sabesp
//
//  Created by Rodrigo Presbiteris on 31/03/15.
//  Copyright (c) 2015 Rodrigo Presbiteris. All rights reserved.
//

import Foundation

struct Manancial {
    var name:String
    var volume:String
    var rainDay:String
    var rainMonth:String
    var rainAvg:String
    
    init(manancialDic:NSDictionary) {
        NSLog("%@", manancialDic);
        
        name = manancialDic["name"] as String
        
        var data = manancialDic["data"] as NSArray
        volume = data[0]["value"] as String
        rainDay = data[1]["value"] as String
        rainMonth = data[2]["value"] as String
        rainAvg = data[3]["value"] as String
    }
    
}