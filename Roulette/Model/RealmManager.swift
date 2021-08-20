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
//        デバッグ用出力　シミュレータのRealmDBのアドレス
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func addRouletteDataSet(dataSet: RouletteItemDataSet) {
        try! database?.write {
            database?.add(dataSet)
        }
    }
    
    func deleteRouletteDataSet(dataSet: RouletteItemDataSet) {
        try! database?.write {
            database.delete(dataSet)
        }
    }
    
    func getFavoriteDataSet() -> Results<RouletteItemDataSet> {
        let results = database!.objects(RouletteItemDataSet.self)
        return results
    }
    
}
