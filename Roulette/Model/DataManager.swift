//
//  DataManager.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/04/11.
//

import Foundation

class DataManager {
    static let dataManagerInstance = DataManager()
    var currentDataSet: RouletteItemDataSet?
    
    func updateSetDataSet(dataSet: RouletteItemDataSet) {
        self.currentDataSet = dataSet
    }
    
    func copyDataSet() -> RouletteItemDataSet {
        let instance = RouletteItemDataSet()
        instance.title = currentDataSet?.title
        instance.dataSet = currentDataSet?.dataSet
        return instance
    }
    
}
