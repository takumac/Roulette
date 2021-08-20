//
//  RouletteItemCell.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/04/09.
//

import UIKit

protocol RouletteItemCellDelegate {
    func textFieldShouldBeginEditing(cell: RouletteItemCell, textField: UITextField) -> ()
    func textFieldDidEndEditing(cell: RouletteItemCell, textField: UITextField) -> ()
    func tapColorButton(button: UIButton)
    func doubleTapGestureAction(cell: RouletteItemCell)
}

class RouletteItemCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var rouletteItemTextField: UITextField!
    @IBOutlet weak var ratioTextField: UITextField!
    @IBOutlet weak var ratioLabel: UILabel!
    
    var delegate: RouletteItemCellDelegate! = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
        
        // ダブルタップでチート設定
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureAction(sender:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    // MARK: - UI setting method
    func setUI() {
        // タグ付け
        rouletteItemTextField.tag = 1
        ratioTextField.tag = 2
        
        // delegate設定
        rouletteItemTextField.delegate = self
        ratioTextField.delegate = self
        
        // AutoLayoutの設定
        // 色選択ボタンの設定
        colorButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        colorButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CGFloat(10)).isActive = true
        colorButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
        colorButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        colorButton.layer.cornerRadius = self.frame.width / 20
        // ルーレット項目の設定
        rouletteItemTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rouletteItemTextField.leadingAnchor.constraint(equalTo: colorButton.trailingAnchor, constant: CGFloat(10)).isActive = true
        rouletteItemTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        rouletteItemTextField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        rouletteItemTextField.translatesAutoresizingMaskIntoConstraints = false
        // 比率項目の設定
        ratioTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ratioTextField.leadingAnchor.constraint(equalTo: rouletteItemTextField.trailingAnchor, constant: CGFloat(10)).isActive = true
        ratioTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: CGFloat(-10)).isActive = true
        ratioTextField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        ratioTextField.translatesAutoresizingMaskIntoConstraints = false
        // 比率用のlabelの設定
        ratioLabel.leadingAnchor.constraint(equalTo: ratioTextField.leadingAnchor).isActive = true
        ratioLabel.bottomAnchor.constraint(equalTo: ratioTextField.topAnchor, constant: CGFloat(-5)).isActive = true
        ratioLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setValue(indexPath:IndexPath, rouletteItemObj: RouletteitemObj) {
        // 色選択ボタン
        colorButton.backgroundColor = UIColor(rouletteItemObj.color)
        colorButton.tag = indexPath.row
        // ルーレット項目
        rouletteItemTextField.text = rouletteItemObj.rouletteItem
        // 比率項目
        ratioTextField.text = String(rouletteItemObj.ratio)
    }
    
    
    // MARK: -textFieldDelegate
    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate.textFieldShouldBeginEditing(cell: self, textField: textField)
        return true
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate.textFieldDidEndEditing(cell: self, textField: textField)
    }
    
    
    // MARK: - button action
    @IBAction func tapColorButton(_ sender: Any) {
        self.delegate.tapColorButton(button: sender as! UIButton)
    }
    
    
    // MARK: - tapGesture method
    @objc func doubleTapGestureAction(sender: AnyObject) {
        self.delegate.doubleTapGestureAction(cell: self)
    }
    
}
