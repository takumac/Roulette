//
//  ColorSelectVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/04/11.
//

import UIKit

class ColorSelectVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var resultHandler: ((UIColor) -> Void)? // 遷移元の色選択ボタンの色を更新するクロージャ変数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        generateColorButton()
    }
    
    
    // MARK: - UI setting method
    func setUI() {
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // scrollViewのAutoLayout設定
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // contentViewのAutoLayout設定
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // ScrollView以外のViewを薄暗くする。ポップアップビューっぽい。
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    func generateColorButton() {
        // 1つの色選択ボタンの幅と高さとボタン間の感覚の定義
        let colorSelectButtonSpace: CGFloat = CGFloat(10) // 間隔
        let colorSelectButtonWidth: CGFloat = self.view.bounds.width * CGFloat(floor((Double(1)/Double(Constants.selectColorArray.count/5))*1000) / 1000) // 幅
        let colorSelectButtonHeight: CGFloat = self.view.bounds.width * CGFloat(floor((Double(1)/Double(Constants.selectColorArray.count/5))*1000) / 1000) // 高さ
        
        // ルーレット項目に選択可能な色を全色表示させる。表示形式は丸ボタン。
        for i in 0..<Constants.selectColorArray.count/5 {
            // 1行につき5個のボタンを配置
            let colorButton1: UIButton = UIButton()
            colorButton1.backgroundColor = Constants.selectColorArray[(5*i)]
            colorButton1.layer.cornerRadius = (colorSelectButtonWidth - colorSelectButtonSpace) / 2
            colorButton1.addTarget(self, action:  #selector(tapColorSelectButton(_:)), for: .touchUpInside)
            
            let colorButton2: UIButton = UIButton()
            colorButton2.backgroundColor = Constants.selectColorArray[(5*i)+1]
            colorButton2.layer.cornerRadius = (colorSelectButtonWidth - colorSelectButtonSpace) / 2
            colorButton2.addTarget(self, action:  #selector(tapColorSelectButton(_:)), for: .touchUpInside)
            
            let colorButton3: UIButton = UIButton()
            colorButton3.backgroundColor = Constants.selectColorArray[(5*i)+2]
            colorButton3.layer.cornerRadius = (colorSelectButtonWidth - colorSelectButtonSpace) / 2
            colorButton3.addTarget(self, action:  #selector(tapColorSelectButton(_:)), for: .touchUpInside)
            
            let colorButton4: UIButton = UIButton()
            colorButton4.backgroundColor = Constants.selectColorArray[(5*i)+3]
            colorButton4.layer.cornerRadius = (colorSelectButtonWidth - colorSelectButtonSpace) / 2
            colorButton4.addTarget(self, action:  #selector(tapColorSelectButton(_:)), for: .touchUpInside)
            
            let colorButton5: UIButton = UIButton()
            colorButton5.backgroundColor = Constants.selectColorArray[(5*i)+4]
            colorButton5.layer.cornerRadius = (colorSelectButtonWidth - colorSelectButtonSpace) / 2
            colorButton5.addTarget(self, action:  #selector(tapColorSelectButton(_:)), for: .touchUpInside)
            
            // ボタンをcontentViewに配置
            contentView.addSubview(colorButton1)
            contentView.addSubview(colorButton2)
            contentView.addSubview(colorButton3)
            contentView.addSubview(colorButton4)
            contentView.addSubview(colorButton5)
            
            // 各種ボタンのAutoLayoutを設定
            colorButton1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: colorSelectButtonSpace/2).isActive = true
            colorButton1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: colorSelectButtonHeight * CGFloat(i) + colorSelectButtonSpace).isActive = true
            colorButton1.widthAnchor.constraint(equalToConstant: colorSelectButtonWidth - colorSelectButtonSpace).isActive = true
            colorButton1.heightAnchor.constraint(equalToConstant: colorSelectButtonHeight - colorSelectButtonSpace).isActive = true
            colorButton1.translatesAutoresizingMaskIntoConstraints = false
            
            colorButton2.leadingAnchor.constraint(equalTo: colorButton1.trailingAnchor, constant: colorSelectButtonSpace).isActive = true
            colorButton2.topAnchor.constraint(equalTo: contentView.topAnchor, constant: colorSelectButtonHeight * CGFloat(i) + colorSelectButtonSpace).isActive = true
            colorButton2.widthAnchor.constraint(equalToConstant: colorSelectButtonWidth - colorSelectButtonSpace).isActive = true
            colorButton2.heightAnchor.constraint(equalToConstant: colorSelectButtonHeight - colorSelectButtonSpace).isActive = true
            colorButton2.translatesAutoresizingMaskIntoConstraints = false

            colorButton3.leadingAnchor.constraint(equalTo: colorButton2.trailingAnchor, constant: colorSelectButtonSpace).isActive = true
            colorButton3.topAnchor.constraint(equalTo: contentView.topAnchor, constant: colorSelectButtonHeight * CGFloat(i) + colorSelectButtonSpace).isActive = true
            colorButton3.widthAnchor.constraint(equalToConstant: colorSelectButtonWidth - colorSelectButtonSpace).isActive = true
            colorButton3.heightAnchor.constraint(equalToConstant: colorSelectButtonHeight - colorSelectButtonSpace).isActive = true
            colorButton3.translatesAutoresizingMaskIntoConstraints = false

            colorButton4.leadingAnchor.constraint(equalTo: colorButton3.trailingAnchor, constant: colorSelectButtonSpace).isActive = true
            colorButton4.topAnchor.constraint(equalTo: contentView.topAnchor, constant: colorSelectButtonHeight * CGFloat(i) + colorSelectButtonSpace).isActive = true
            colorButton4.widthAnchor.constraint(equalToConstant: colorSelectButtonWidth - colorSelectButtonSpace).isActive = true
            colorButton4.heightAnchor.constraint(equalToConstant: colorSelectButtonHeight - colorSelectButtonSpace).isActive = true
            colorButton4.translatesAutoresizingMaskIntoConstraints = false

            colorButton5.leadingAnchor.constraint(equalTo: colorButton4.trailingAnchor, constant: colorSelectButtonSpace).isActive = true
            colorButton5.topAnchor.constraint(equalTo: contentView.topAnchor, constant: colorSelectButtonHeight * CGFloat(i) + colorSelectButtonSpace).isActive = true
            colorButton5.widthAnchor.constraint(equalToConstant: colorSelectButtonWidth - colorSelectButtonSpace).isActive = true
            colorButton5.heightAnchor.constraint(equalToConstant: colorSelectButtonHeight - colorSelectButtonSpace).isActive = true
            colorButton5.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    // MARK: - button action method
    @objc func tapColorSelectButton(_ sender: UIButton) {
        
        if let handler = self.resultHandler {
            handler(sender.backgroundColor!)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
