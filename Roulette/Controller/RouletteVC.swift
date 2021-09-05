//
//  RouletteVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/04/07.
//

import UIKit
import Charts
import MaterialComponents

class RouletteVC: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var rouletteView: PieChartView!
    @IBOutlet weak var buttonAreaView: UIView!
    @IBOutlet weak var startButton: MDCRaisedButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var rouletteItemDataSet: RouletteItemDataSet?
    var needleView: UIImageView?
    var rouletteTime: Int?
    var resultAngle: UInt32 = UInt32()
    
    var resultRouletteItem: RouletteitemObj?
    var resultIndex: Int?
    
    var cheatItemIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rouletteView.delegate = self
        if UserDefaults.standard.object(forKey: "rouletteTime") != nil {
            rouletteTime = UserDefaults.standard.integer(forKey: "rouletteTime")
        } else {
            rouletteTime = 3
        }
        
        // AutoLayout
        titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        rouletteView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        rouletteView.bottomAnchor.constraint(equalTo: startButton.topAnchor).isActive = true
        rouletteView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        rouletteView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        rouletteView.translatesAutoresizingMaskIntoConstraints = false

        buttonAreaView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        buttonAreaView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        buttonAreaView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        buttonAreaView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        buttonAreaView.translatesAutoresizingMaskIntoConstraints = false

        startButton.centerXAnchor.constraint(equalTo: buttonAreaView.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: buttonAreaView.centerYAnchor).isActive = true
        startButton.widthAnchor.constraint(equalTo: buttonAreaView.widthAnchor, multiplier: 0.8).isActive = true
        startButton.heightAnchor.constraint(equalTo: buttonAreaView.heightAnchor, multiplier: 0.7).isActive = true
        startButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUI()
        // ルーレット項目の設定
        if DataManager.dataManagerInstance.currentDataSet != nil {
            rouletteItemDataSet = DataManager.dataManagerInstance.copyDataSet()
        } else {
            rouletteItemDataSet = RouletteItemDataSet()
        }
        
        PieChartViewManager.setPieChartView(chartView: rouletteView)
        PieChartViewManager.setRouletteItem(chartView: rouletteView, rouletteItemDataSet: rouletteItemDataSet ?? nil)
        // タイトル設定
        titleLabel.text = rouletteItemDataSet?.title
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        displayNeedle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    // MARK: - button action method
    @IBAction func tapStartButton(_ sender: Any) {
        startButton.isEnabled = false
        
        if (UserDefaults.standard.bool(forKey: "cheatFlg") == true) && (DataManager.dataManagerInstance.currentDataSet?.dataSet.count == self.rouletteItemDataSet?.dataSet.count) { // 出来レースOn&&ルーレット1回目の時
            let resultAngleFrom = PieChartViewManager.getCheatAngleFrom(rouletteItemDataSet: rouletteItemDataSet, cheatIndex: cheatItemIndex)
            let resultAngleTo = PieChartViewManager.getCheatAngleTo(rouletteItemDataSet: rouletteItemDataSet, cheatIndex: cheatItemIndex)
            
            resultAngle = 360 - UInt32(resultAngleTo - ((resultAngleTo - resultAngleFrom) / 2.0))
        } else {
            resultAngle = arc4random_uniform(360 + 1)
        }
        rouletteSpin(duration: 3, fromAngle: 270, toAngle: CGFloat(270 + Int(resultAngle) + (360 * rouletteTime!)), easing: nil)
    }
    
    
    // MARK: - spin Method
    func rouletteSpin(duration: TimeInterval, fromAngle: CGFloat, toAngle: CGFloat, easing: ChartEasingFunctionBlock?) {
        var _spinAnimator: Animator!
        if _spinAnimator != nil
        {
            _spinAnimator.stop()
        }

        _spinAnimator = Animator()
        _spinAnimator.delegate = self.rouletteView
        _spinAnimator.updateBlock = {
            self.rouletteView.rotationAngle = (toAngle - fromAngle) * CGFloat(_spinAnimator.phaseX) + fromAngle
        }
        _spinAnimator.stopBlock = { _spinAnimator = nil }
        
        _spinAnimator.animate(xAxisDuration: duration, easing: easing)
    }
    
    
    // MARK: - ChartViewDelegate Method
    @objc func chartView(_ chartView: ChartViewBase, animatorDidStop animator: Animator) {
        if rouletteTime! <= 0 {
            performSegue(withIdentifier: "toResultViewSegue", sender: nil)
            
            resultAngle = 0
            if UserDefaults.standard.object(forKey: "rouletteTime") != nil {
                rouletteTime = UserDefaults.standard.integer(forKey: "rouletteTime")
            } else {
                rouletteTime = 3
            }
            startButton.isEnabled = true
            return
        } else {
            rouletteSpin(duration: 3, fromAngle: CGFloat(270 + resultAngle), toAngle: CGFloat(270 + Int(resultAngle) + (360 * rouletteTime!)), easing: nil)
        }
        
        rouletteTime! -= 1
    }
    
    
    // MARK: - UI setting method
    func setUI() {
        // タイトルラベルのUI設定
        titleLabel.attributedText = NSAttributedString(string: titleLabel.text!, attributes: Constants.titleLabelAttributes)
        // StartボタンのUI設定
        startButton.setAttributedTitle(NSAttributedString(string: (startButton.titleLabel?.text)!, attributes: Constants.buttonLabelAttributes), for: .normal)
        startButton.layer.cornerRadius = Constants.defaultCornerRadius
        // 背景色設定
        if let setColor = UserDefaults.standard.object(forKey: "backGroundColor") as? Data {
            let reloadColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(setColor) as? UIColor
            self.view.backgroundColor = reloadColor
            self.buttonAreaView.backgroundColor = reloadColor
        } else {
            self.view.backgroundColor = Constants.backGroundColorPalette.palette[0].color
            self.buttonAreaView.backgroundColor = Constants.backGroundColorPalette.palette[0].color
        }
    }
    
    func displayNeedle() {
        // ルーレットの針の描画設定
        let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
        needleView = UIImageView(image: UIImage(named: "needle")!)
        self.view.addSubview(needleView!)
        // ルーレットの針のAutoLayout
        needleView?.centerXAnchor.constraint(equalTo: self.rouletteView.centerXAnchor).isActive = true
        needleView?.topAnchor.constraint(equalTo: self.rouletteView.topAnchor, constant: (safeAreaHeight/10.0)*0.5).isActive = true
        needleView?.widthAnchor.constraint(equalTo: self.rouletteView.widthAnchor, multiplier: 0.15).isActive = true
        needleView?.heightAnchor.constraint(equalTo: self.rouletteView.heightAnchor, multiplier: 0.15).isActive = true
        needleView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: - Segue method
    //画面遷移時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? ResultVC { // 遷移先が結果表示画面の場合
            resultRouletteItem = PieChartViewManager.getSelectedData(rouletteItemDataSet: rouletteItemDataSet, angle: Double(resultAngle))
            resultIndex = PieChartViewManager.getSelectedDataIndex(rouletteItemDataSet: rouletteItemDataSet, angle: Double(resultAngle))
            if resultRouletteItem?.rouletteItem == nil {
                resultRouletteItem = RouletteitemObj()
            }
            
            resultVC.continueActionHandler = { // Continueボタンの制御
                self.rouletteItemDataSet?.dataSet.remove(at: self.resultIndex!)
                PieChartViewManager.setRouletteItem(chartView: self.rouletteView, rouletteItemDataSet: self.rouletteItemDataSet ?? nil)
            }
            
            resultVC.resetActionHandler = { // Resetボタンの制御
                self.rouletteItemDataSet = DataManager.dataManagerInstance.copyDataSet()
                PieChartViewManager.setRouletteItem(chartView: self.rouletteView, rouletteItemDataSet: self.rouletteItemDataSet)
            }
            
            resultVC.rouletteItemCount = self.rouletteItemDataSet!.dataSet.count
            resultVC.resultItem = resultRouletteItem!.rouletteItem
        }
    }
}
