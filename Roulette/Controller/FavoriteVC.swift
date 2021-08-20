//
//  FavoriteVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/08/02.
//

import UIKit
import RealmSwift

class FavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoriteItemCellDelegate {
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
        cell.selectionStyle = .none

        if let setColor = UserDefaults.standard.object(forKey: "backGroundColor") as? Data {
            let reloadColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(setColor) as? UIColor
            cell.contentView.backgroundColor = reloadColor
        } else {
            cell.contentView.backgroundColor = Constants.backGroundColorPalette.palette[0].color
        }

        if let favoriteDataSets = favoriteDataSet {
            let favoriteData = favoriteDataSets[indexPath.row]
            cell.setValue(indexPath: indexPath, rouletteItemDataSet: favoriteData)
            cell.delegate = self
        }
        return cell
    }
    
    
    // MARK: - tableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight / 1.5
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:"delete") { (ctxAction, view, completionHandler) in
            guard let favoriteDataSets = self.favoriteDataSet else {
                return
            }
            
            RealmManager.realmManagerInstance.deleteRouletteDataSet(dataSet: favoriteDataSets[indexPath.row])
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at:[IndexPath(row: indexPath.row, section: 0)], with:.automatic)
            self.tableView.endUpdates()
            completionHandler(true)
        }
        
        let trashImage = UIImage(systemName: "trash.fill")?.withTintColor(UIColor.white , renderingMode: .alwaysTemplate)
        deleteAction.image = trashImage
        deleteAction.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        
        let swipeAction = UISwipeActionsConfiguration(actions:[deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
    
    
    // MARK: - FavoriteIemCellDelegate method
    func tapGestureAction(cell: UITableViewCell) {
        guard let favoriteDataSets = favoriteDataSet else {
            return
        }
        
        let tappedIndexPath = tableView.indexPath(for: cell)
        if let tappedRow = tappedIndexPath?.row {
            let favoriteDataSet = favoriteDataSets[tappedRow]
            let copyDataSet = DataManager.dataManagerInstance.copyDataSet(rouletteItemDataSet: favoriteDataSet)
            
            let alert: UIAlertController = UIAlertController(title: copyDataSet.title, message: "ルーレットにセットしてもよろしいですか？", preferredStyle: UIAlertController.Style.alert)
            let setAction: UIAlertAction = UIAlertAction(title: "設定", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> Void in
                DataManager.dataManagerInstance.updateSetDataSet(dataSet: copyDataSet)
                self.navigationController?.popViewController(animated: true)
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction!) -> Void in
                
            })
            
            alert.addAction(setAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
    }

}
