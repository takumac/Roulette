//
//  PieChartViewManager.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/04/17.
//

import Foundation
import Charts

class PieChartViewManager {
    static func setPieChartView(chartView: PieChartView) {
        chartView.highlightPerTapEnabled = false     // ルーレットの項目がタップされた時のハイライトをOFF
        chartView.drawHoleEnabled = false            // ルーレットは真ん中まで塗りつぶす
        chartView.rotationEnabled = false            // ルーレットの回転をさせない
        chartView.legend.enabled = false             // 下部に表示されるルーレット項目の注釈は非表示
    }
    
    
    static func setRouletteItem(chartView: PieChartView, rouletteItemDataSet: RouletteItemDataSet?) {
        guard let dataSet = rouletteItemDataSet else {
            return
        }
        // ルーレット項目を設定
        var rouletteItemData: [PieChartDataEntry] = []
        var rouletteItemColor: [UIColor] = []
        for i in 0..<dataSet.dataSet.count {
            let pieChartData = PieChartDataEntry(value: Double(dataSet.dataSet[i].ratio), label: dataSet.dataSet[i].rouletteItem)
            rouletteItemData.append(pieChartData)
            rouletteItemColor.append(UIColor(dataSet.dataSet[i].color))
        }
        
        let pieChartDataSet = PieChartDataSet(entries: rouletteItemData)
        pieChartDataSet.colors = rouletteItemColor
        pieChartDataSet.entryLabelColor = .black
        pieChartDataSet.drawValuesEnabled = false
        
        chartView.data = PieChartData(dataSet: pieChartDataSet)
    }
    
    
    static func getSelectedData(rouletteItemDataSet: RouletteItemDataSet?, angle: Double) -> RouletteitemObj? {
        guard let dataSet = rouletteItemDataSet else {
            return nil
        }
        
        let ratioPerArray = (0..<dataSet.dataSet.count).map { (i) -> Double in
            return (Double(dataSet.dataSet[i].ratio) / Double(getRange(rouletteItemDateSet: dataSet)))
        }
        
        let angleRatio = angle / 360.0
        var sum = 0.0
        var indexCount = dataSet.dataSet.count - 1
        
        for index in (0..<ratioPerArray.count).reversed() {
            sum += ratioPerArray[index]
            if angleRatio <= Double(sum) {
                break
            }
            indexCount -= 1
        }
        return dataSet.dataSet[indexCount]
    }
    
    
    static func getSelectedDataIndex(rouletteItemDataSet: RouletteItemDataSet?, angle: Double) -> Int {
        guard let dataSet = rouletteItemDataSet else {
            return 0
        }
        
        let ratioPerArray = (0..<dataSet.dataSet.count).map { (i) -> Double in
            return (Double(dataSet.dataSet[i].ratio) / Double(getRange(rouletteItemDateSet: dataSet)))
        }
        
        let angleRatio = angle / 360.0
        var sum = 0.0
        var indexCount = dataSet.dataSet.count - 1
        
        for index in (0..<ratioPerArray.count).reversed() {
            sum += ratioPerArray[index]
            if angleRatio <= Double(sum) {
                break
            }
            indexCount -= 1
        }
        return indexCount
    }
    
    
    static func getCheatAngleFrom(rouletteItemDataSet: RouletteItemDataSet?, cheatIndex: Int) -> Double {
        guard let dataSet = rouletteItemDataSet else {
            return 0
        }
        
        let ratioPerArray = (0..<dataSet.dataSet.count).map { (i) -> Double in
            return (Double(dataSet.dataSet[i].ratio) / Double(getRange(rouletteItemDateSet: dataSet)))
        }
        
        var sum = 0.0
        for index in (0..<cheatIndex).reversed() {
            sum += ratioPerArray[index]
        }
        
        return sum * 360.0
    }
    
    
    static func getCheatAngleTo(rouletteItemDataSet: RouletteItemDataSet?, cheatIndex: Int) -> Double {
        guard let dataSet = rouletteItemDataSet else {
            return 0
        }
        
        let ratioPerArray = (0..<dataSet.dataSet.count).map { (i) -> Double in
            return (Double(dataSet.dataSet[i].ratio) / Double(getRange(rouletteItemDateSet: dataSet)))
        }
        
        var sum = 0.0
        for index in (0..<cheatIndex+1).reversed() {
            sum += ratioPerArray[index]
        }
        
        return sum * 360.0
    }
    
    static func getRange(rouletteItemDateSet: RouletteItemDataSet) -> Int {
        var countSum = 0
        for i in 0..<rouletteItemDateSet.dataSet.count {
            countSum += rouletteItemDateSet.dataSet[i].ratio
        }
        
        return countSum
    }
}
