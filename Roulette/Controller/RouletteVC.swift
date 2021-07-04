//
//  RouletteVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/04/07.
//

import UIKit
import Charts

class RouletteVC: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var rouletteView: PieChartView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var rouletteItemDataSet: RouletteItemDataSet?
    var needleView: UIImageView?
    var rouletteTime: Int?
    var resultAngle: UInt32 = UInt32()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rouletteView.delegate = self
        rouletteTime = Constants.rouletteTime
        
        // AutoLayout
        // ラベルのAutoLayout
        titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // ルーレットのAutoLayout
        rouletteView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        rouletteView.bottomAnchor.constraint(equalTo: startButton.topAnchor).isActive = true
        rouletteView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        rouletteView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        rouletteView.translatesAutoresizingMaskIntoConstraints = false
        // ルーレットのスタートボタンのAutoLayout
        startButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        startButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        startButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        startButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
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
        rouletteSpin(duration: 3, fromAngle: 270, toAngle: CGFloat(270 + (360 * rouletteTime!)), easing: nil)
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
        if rouletteTime! < 0 {
            var resultRouletteItem = PieChartViewManager.getSelectedData(rouletteItemDataSet: rouletteItemDataSet, angle: Double(resultAngle))
            let resultIndex = PieChartViewManager.getSelectedDataIndex(rouletteItemDataSet: rouletteItemDataSet, angle: Double(resultAngle))
            if resultRouletteItem?.rouletteItem == nil {
                resultRouletteItem = RouletteitemObj()
            }
            let alertController = UIAlertController(title: "Result",
                                                    message: "選択されたのは " + resultRouletteItem!.rouletteItem + " です",
                                                    preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Continue", style: .default) { (action: UIAlertAction) in
                self.rouletteItemDataSet?.dataSet.remove(at: resultIndex)
                PieChartViewManager.setRouletteItem(chartView: self.rouletteView, rouletteItemDataSet: self.rouletteItemDataSet ?? nil)
            }
            let resetAction = UIAlertAction(title: "Reset", style: .default) { (action: UIAlertAction) in
                self.rouletteItemDataSet = DataManager.dataManagerInstance.copyDataSet()
                PieChartViewManager.setRouletteItem(chartView: self.rouletteView, rouletteItemDataSet: self.rouletteItemDataSet)
            }
            alertController.addAction(continueAction)
            alertController.addAction(resetAction)
            present(alertController, animated: true, completion: nil)
            
            resultAngle = 0
            rouletteTime = Constants.rouletteTime
            startButton.isEnabled = true
            return
        }
        
        if rouletteTime! == 0 {
            resultAngle = arc4random_uniform(360 + 1)
            rouletteSpin(duration: 3, fromAngle: 270, toAngle: CGFloat(270 + resultAngle), easing: nil)
        } else {
            rouletteSpin(duration: 3, fromAngle: 270, toAngle: CGFloat(270 + (360 * rouletteTime!)), easing: nil)
        }
        
        rouletteTime! -= 1
    }
    
    
    // MARK: - UI setting method
    func setUI() {
        // タイトルラベルのUI設定
        titleLabel.attributedText = NSAttributedString(string: titleLabel.text!, attributes: Constants.titleLabelAttributes)
        // StartボタンのUI設定
        startButton.setAttributedTitle(NSAttributedString(string: (startButton.titleLabel?.text)!, attributes: Constants.buttonLabelAttributes), for: .normal)
        // 背景色設定
        if let setColor = UserDefaults.standard.object(forKey: "backGroundColor") as? Data {
            let reloadColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(setColor) as? UIColor
            self.view.backgroundColor = reloadColor
        } else {
            self.view.backgroundColor = Constants.backGroundColorPalette.palette[0].color
        }
    }
    
    func displayNeedle() {
        // ルーレットの針の描画設定
        let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
        needleView = UIImageView(image: UIImage(named: "needle_gray")!)
        self.view.addSubview(needleView!)
        // ルーレットの針のAutoLayout
        needleView?.centerXAnchor.constraint(equalTo: self.rouletteView.centerXAnchor).isActive = true
        needleView?.topAnchor.constraint(equalTo: self.rouletteView.topAnchor, constant: (safeAreaHeight/10.0)*0.5).isActive = true
        needleView?.widthAnchor.constraint(equalTo: self.rouletteView.widthAnchor, multiplier: 0.15).isActive = true
        needleView?.heightAnchor.constraint(equalTo: self.rouletteView.heightAnchor, multiplier: 0.2).isActive = true
        needleView?.translatesAutoresizingMaskIntoConstraints = false
    }
}
