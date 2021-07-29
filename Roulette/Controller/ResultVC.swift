//
//  ResultVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/07/10.
//

import UIKit
import MaterialComponents

class ResultVC: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var continueButton: MDCRaisedButton!
    @IBOutlet weak var resetButton: MDCRaisedButton!
    
    var continueActionHandler: (() -> (Void))?
    var resetActionHandler: (() -> (Void))?
    var rouletteItemCount: Int!
    var resultItem: String!
    
    let button = MDCButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        self.resultLabel.text = resultItem
        
        // AutoLayout
        resultLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        resultLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: CGFloat(-50)).isActive = true
        resultLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -CGFloat(self.view.frame.width / 4)).isActive = true
        continueButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: CGFloat(100)).isActive = true
        continueButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        continueButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        resetButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: CGFloat(self.view.frame.width / 4)).isActive = true
        resetButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: CGFloat(100)).isActive = true
        resetButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        resetButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        resetButton.translatesAutoresizingMaskIntoConstraints = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UI setting method
    func setUI() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        continueButton.layer.cornerRadius = Constants.defaultCornerRadius
        resetButton.layer.cornerRadius = Constants.defaultCornerRadius
        
        if rouletteItemCount < 3 {
            self.continueButton.isEnabled = false
            self.continueButton.alpha = 0.3
        }
    }
    
    // MARK: - button action method
    @IBAction func tapContinueButton(_ sender: Any) {
        continueActionHandler!()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapResetButton(_ sender: Any) {
        resetActionHandler!()
        self.dismiss(animated: true, completion: nil)
    }
}
