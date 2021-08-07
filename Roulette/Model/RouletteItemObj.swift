//
//  RouletteItemObj.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/04/10.
//

import Foundation
import UIKit
import RealmSwift

class RouletteitemObj: Object {
    @objc dynamic var rouletteItem: String!
    @objc dynamic var ratio: Int = 1
    @objc dynamic var color: String!
    
    override init() {
        super.init()
        
        rouletteItem = ""
        ratio = 1
        color = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).hexString()
    }
    
}

