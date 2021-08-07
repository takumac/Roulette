//
//  ExtensionString.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/08/07.
//

import Foundation

extension String {
    // 左から文字埋めする
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
