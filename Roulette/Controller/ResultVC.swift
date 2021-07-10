//
//  ResultVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/07/10.
//

import UIKit

class ResultVC: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var continueActionHandler: (() -> (Void))?
    var resetActionHandler: (() -> (Void))?
    var rouletteItemCount: Int!
    var resultItem: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.resultLabel.text = resultItem
        
        if rouletteItemCount < 3 {
            self.continueButton.isEnabled = false
            self.continueButton.alpha = 0.3
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

    @IBAction func tapContinueButton(_ sender: Any) {
        continueActionHandler!()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapResetButton(_ sender: Any) {
        resetActionHandler!()
        self.dismiss(animated: true, completion: nil)
    }
}
