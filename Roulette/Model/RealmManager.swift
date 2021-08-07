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
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        database = try! Realm(configuration: config)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func addRouletteDataSet() {
        let addDataSet: RouletteItemDataSet = DataManager.dataManagerInstance.copyDataSet()
        try! database?.write {
            database?.add(addDataSet)
        }
    }
    
    func getFavoriteDataSet() -> Results<RouletteItemDataSet> {
        let results = database!.objects(RouletteItemDataSet.self)
        return results
    }
    
}
