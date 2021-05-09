//
//  Constants.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/04/11.
//

import Foundation
import UIKit

struct Constants {
    // 各ルーレット項目の色を保持する配列
    static let selectColorArray: [UIColor] = [
        UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1),
        UIColor(red: 255/255, green: 102/255, blue: 0/255, alpha: 1),
        UIColor(red: 255/255, green: 153/255, blue: 0/255, alpha: 1),
        UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1),
        UIColor(red: 255/255, green: 0/255, blue: 102/255, alpha: 1),
        UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1),
        UIColor(red: 255/255, green: 153/255, blue: 102/255, alpha: 1),
        UIColor(red: 255/255, green: 255/255, blue: 102/255, alpha: 1),
        UIColor(red: 204/255, green: 0/255, blue: 255/255, alpha: 1),
        UIColor(red: 204/255, green: 102/255, blue: 255/255, alpha: 1),
        UIColor(red: 204/255, green: 153/255, blue: 255/255, alpha: 1),
        UIColor(red: 204/255, green: 255/255, blue: 255/255, alpha: 1),
        UIColor(red: 153/255, green: 255/255, blue: 0/255, alpha: 1),
        UIColor(red: 153/255, green: 255/255, blue: 102/255, alpha: 1),
        UIColor(red: 153/255, green: 255/255, blue: 255/255, alpha: 1),
        UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1),
        UIColor(red: 153/255, green: 153/255, blue: 255/255, alpha: 1),
        UIColor(red: 153/255, green: 102/255, blue: 255/255, alpha: 1),
        UIColor(red: 153/255, green: 0/255, blue: 255/255, alpha: 1),
        UIColor(red: 51/255, green: 255/255, blue: 0/255, alpha: 1),
        UIColor(red: 51/255, green: 255/255, blue: 102/255, alpha: 1),
        UIColor(red: 51/255, green: 255/255, blue: 204/255, alpha: 1),
        UIColor(red: 51/255, green: 204/255, blue: 255/255, alpha: 1),
        UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1),
        UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    ]
    
    // 1セルあたりの高さ
    static let cellHeight: CGFloat = 90
    
    // ルーレットの長さ
    static let rouletteTime: Int = 4
    
    // ルーレット画面のタイトルのフォント
    static let titleLabelAttributes : [NSAttributedString.Key : Any] =
        [
            .font : UIFont.systemFont(ofSize: 30),
            .foregroundColor : UIColor.black,
        ]
    
    // 各種ボタンの文字フォント
    static let buttonLabelAttributes : [NSAttributedString.Key : Any] =
        [
            .font : UIFont.systemFont(ofSize: 20),
            .foregroundColor : UIColor.red
        ]
    
    // 各画面の背景色
    static let commmonBackGroundColor : UIColor = UIColor(cgColor: CGColor(red: 0.9168970293, green: 0.9977688411, blue: 0.9045526756, alpha: 1.0))
}

