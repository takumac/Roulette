//
//  FavoriteVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/08/02.
//

import UIKit
import RealmSwift

class FavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteDataSet: Results<RouletteItemDataSet>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        // AutoLayout
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteDataSet = RealmManager.realmManagerInstance.getFavoriteDataSet()
        
        if let setColor = UserDefaults.standard.object(forKey: "backGroundColor") as? Data {
            let reloadColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(setColor) as? UIColor
            tableView.backgroundColor = reloadColor
            self.view.backgroundColor = reloadColor
        } else {
            tableView.backgroundColor = Constants.backGroundColorPalette.palette[0].color
            self.view.backgroundColor = Constants.backGroundColorPalette.palette[0].color
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FavoriteItemCell", bundle: nil), forCellReuseIdentifier: "favoriteItemCell")
    }
    
    // MARK: - tableView DataSouce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSetCount = favoriteDataSet?.count {
            return dataSetCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteItemCell", for: indexPath) as! FavoriteItemCell

        if let setColor = UserDefaults.standard.object(forKey: "backGroundColor") as? Data {
            let reloadColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(setColor) as? UIColor
            cell.contentView.backgroundColor = reloadColor
        } else {
            cell.contentView.backgroundColor = Constants.backGroundColorPalette.palette[0].color
        }

        if let favoriteDataSets = favoriteDataSet {
            let favoriteData = favoriteDataSets[indexPath.row]
            cell.setValue(indexPath: indexPath, rouletteItemDataSet: favoriteData)
        }
        return cell
    }
    
    // MARK: - tableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let favoriteDataSets = favoriteDataSet else {
            return
        }
        
        let favoriteDataSet = favoriteDataSets[indexPath.row]
        let copyDataSet = DataManager.dataManagerInstance.copyDataSet(rouletteItemDataSet: favoriteDataSet)
        DataManager.dataManagerInstance.updateSetDataSet(dataSet: copyDataSet)
    }

}
