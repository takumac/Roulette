//
//  AppSettingVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/05/03.
//

import UIKit
import Eureka
import ColorPickerRow

class AppSettingVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 背景色設定
        if let setColor = UserDefaults.standard.object(forKey: "backGroundColor") as? Data {
            let reloadColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(setColor) as? UIColor
            self.tableView.backgroundColor = reloadColor
        } else {
            self.tableView.backgroundColor = Constants.backGroundColorPalette.palette[0].color
        }
        
        // 設定フォーム
        form
            +++ Section("アプリ設定")
                // ルーレット時間の設定
                <<< SegmentedRow<String>() {
                    $0.title = "ルーレット時間"
                    $0.options = ["short", "normal", "long"]
                    switch UserDefaults.standard.integer(forKey: "rouletteTime") {
                    case 2:
                        $0.value = "short"
                        break
                    case 3:
                        $0.value = "normal"
                        break
                    case 4:
                        $0.value = "long"
                        break
                    default:
                        $0.value = "normal"
                    }
                }.onChange{ row in
                    let selectValue = row.value ?? ""
                    switch selectValue {
                    case "short":
                        UserDefaults.standard.set(2, forKey: "rouletteTime")
                        break
                    case "normal":
                        UserDefaults.standard.set(3, forKey: "rouletteTime")
                        break
                    case "long":
                        UserDefaults.standard.set(4, forKey: "rouletteTime")
                        break
                    default:
                        UserDefaults.standard.set(3, forKey: "rouletteTime")
                        break
                    }
                }
                // テーマカラーの設定
                <<< InlineColorPickerRow() {
                    $0.title = "テーマカラー"
                    $0.isCircular = false
                    $0.showsPaletteNames = true
                    if let setColor = UserDefaults.standard.object(forKey: "backGroundColor") as? Data {
                        let reloadColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(setColor) as? UIColor
                        $0.value = reloadColor
                    } else {
                        $0.value = Constants.backGroundColorPalette.palette[0].color
                    }
                }.cellSetup{ (cell, row) in
                    row.palettes.insert(Constants.backGroundColorPalette, at: 0)
                }.onChange{ (picker) in
                    let selectColor = picker.value!
                    self.tableView.backgroundColor = selectColor
                    guard let setColor = try? NSKeyedArchiver.archivedData(withRootObject: selectColor, requiringSecureCoding: true) else {
                        fatalError("Archive failed")
                    }
                    UserDefaults.standard.set(setColor, forKey: "backGroundColor")
                    UserDefaults.standard.synchronize()
                }
                // チートフラグ設定
                <<< SwitchRow() {
                    $0.title = "出来レース"
                    $0.value = UserDefaults.standard.bool(forKey: "cheatFlg")
                }.onChange({ row in
                    UserDefaults.standard.set(row.value, forKey: "cheatFlg")
                })
                <<< PushRow<String>() {
                    $0.title = "出来レースについて"
                }
            +++ Section("情報")
                // アプリバージョン
                <<< LabelRow() {
                    $0.title = "バージョン"
                    $0.value = "1.0.0"
                }
                // デベロッパー情報
                <<< PushRow<String>() {
                    $0.title = "開発者"
                }
                <<< PushRow<String>() {
                    $0.title = "レビューする"
                }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
