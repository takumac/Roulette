//
//  RealmManager.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/07/30.
//

import Foundation
import RealmSwift

class RealmManager {
    static let realmManagerInstance = RealmManager()
    private var database: Realm!
    
    private init() {
        database = try! Realm()
    }
    
    func addRouletteDataSet(object: RouletteItemDataSet) {
        try! database?.write {
            database?.add(object)
        }
    }
    
}
