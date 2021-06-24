//
//  AppSettingVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/05/03.
//

import UIKit

class AppSettingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let testLabel: UILabel = UILabel();
        testLabel.text = "Hello World!!!!";
        testLabel.textColor = .red;
        
        self.view.addSubview(testLabel);
        testLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        testLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true;
        testLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true;
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
