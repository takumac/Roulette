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
    var dataSet: List<RouletteitemObj>
    
    override init() {
        title = ""
        dataSet = List<RouletteitemObj>()
    }
}
