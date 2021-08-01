//
//  RouletteItemDataSet.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/04/11.
//

import Foundation
import RealmSwift

class RouletteItemDataSet: Object {
    @objc dynamic var title: String!
    var dataSet: [RouletteitemObj]!
    
    override init() {
        super.init()
        
        title = ""
        dataSet = []
    }
}
