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
    
    func updateSetDataSet(dataSet: RouletteItemDataSet, title: String) {
        self.currentDataSet = dataSet
    }
    
    func copyDataSet() -> RouletteItemDataSet {
        let instance = RouletteItemDataSet()
        
        instance.title = currentDataSet!.title
        for item in currentDataSet!.dataSet {
            instance.dataSet.append(RouletteitemObj(value: item))
        }
        
        return instance
    }
    
    func copyDataSet(rouletteItemDataSet: RouletteItemDataSet) -> RouletteItemDataSet {
        let instance = RouletteItemDataSet()
        
        instance.title = rouletteItemDataSet.title
        for item in rouletteItemDataSet.dataSet {
            instance.dataSet.append(RouletteitemObj(value: item))
        }
        
        return instance
    }
    
}
