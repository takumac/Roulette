//
//  AppSettingVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/05/03.
//

import UIKit
import Eureka

class AppSettingVC: FormViewController {
    var type:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.backgroundColor = Constants.commmonBackGroundColor
        form
            +++ Section("hogehoge")
            <<< TextRow() { row in
                row.title = "TextRow"
                row.placeholder = "TextRow"
            }
            <<< PhoneRow() {
                $0.title = "数値入力2"
                $0.placeholder = "hohohohoho"
            }
            <<< IntRow() { row in
                row.title = "IntRow"
                row.placeholder = "IntRow"
            }
            <<< DateRow() {
                $0.title = "DateRow"
            }
            <<< PushRow<String>() {
                $0.title = "type"
                $0.options = ["a","b","c","d"]
                $0.value = "a"
                $0.selectorTitle = "select type"
                self.type = $0.value ?? "type"
            }
            <<< SegmentedRow<String>() {
                $0.title = "ルーレット速度"
                $0.options = ["slow", "normal", "fast"]
                $0.value = "slow"
            }
            <<< SwitchRow() {
                $0.title = "チートスイッチ"
                $0.value = false
            }.onChange({ row in
                
            })
            
            
            +++ Section("foofoo")
            <<< PhoneRow() {
                $0.title = "foofoo"
                $0.placeholder = "yoroshiku"
            }
        
            +++ ButtonRow("Button") { row in
                row.tag = "delete_row"
                row.title = "buttonrow"
                
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
