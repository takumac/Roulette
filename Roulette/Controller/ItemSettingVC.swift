//
//  ItemSettingVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/04/06.
//

import UIKit
import MaterialComponents
import RealmSwift

class ItemSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RouletteItemCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonAreaView: UIView!
    
    @IBOutlet weak var addButton: MDCRaisedButton!
    @IBOutlet weak var favoriteButton: MDCRaisedButton!
    
    
    var rouletteItemDataSet: RouletteItemDataSet!
    var cheatItemIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        
        // AutoLayout
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonAreaView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        buttonAreaView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        buttonAreaView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        buttonAreaView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        buttonAreaView.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.centerXAnchor.constraint(equalTo: buttonAreaView.centerXAnchor, constant: -CGFloat(self.view.frame.width / 4)).isActive = true
        addButton.centerYAnchor.constraint(equalTo: buttonAreaView.centerYAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: buttonAreaView.widthAnchor, multiplier: 0.4).isActive = true
        addButton.heightAnchor.constraint(equalTo: buttonAreaView.heightAnchor, multiplier: 0.7).isActive = true
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteButton.centerXAnchor.constraint(equalTo: buttonAreaView.centerXAnchor, constant: CGFloat(self.view.frame.width / 4)).isActive = true
        favoriteButton.centerYAnchor.constraint(equalTo: buttonAreaView.centerYAnchor).isActive = true
        favoriteButton.widthAnchor.constraint(equalTo: buttonAreaView.widthAnchor, multiplier: 0.4).isActive = true
        favoriteButton.heightAnchor.constraint(equalTo: buttonAreaView.heightAnchor, multiplier: 0.7).isActive = true
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let dataSet = DataManager.dataManagerInstance.currentDataSet {
            rouletteItemDataSet = dataSet
        } else {
            rouletteItemDataSet = RouletteItemDataSet()
        }
        // ???????????????
        if let setColor = UserDefaults.standard.object(forKey: "backGroundColor") as? Data {
            let reloadColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(setColor) as? UIColor
            tableView.backgroundColor = reloadColor
            buttonAreaView.backgroundColor = reloadColor
            self.view.backgroundColor = reloadColor
        } else {
            tableView.backgroundColor = Constants.backGroundColorPalette.palette[0].color
            buttonAreaView.backgroundColor = Constants.backGroundColorPalette.palette[0].color
            self.view.backgroundColor = Constants.backGroundColorPalette.palette[0].color
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // ????????????????????????????????????
        setNavigationBar()
        
        tableView.reloadData()
        registerNotification()
        
        // ??????????????????(TextField?????????????????????)???????????????????????????????????????????????????????????????
        let singleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        singleTapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotification()
    }
    
    
    // MARK: - UI setting method
    func setUI() {
        // tableView?????????
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RouletteItemCell", bundle: nil), forCellReuseIdentifier: "rouletteItemCell")
        // ??????????????????????????????
        addButton.setAttributedTitle(NSAttributedString(string: (addButton.titleLabel?.text)!, attributes: Constants.buttonLabelAttributes), for: .normal)
        addButton.layer.cornerRadius = Constants.defaultCornerRadius
        // ?????????????????????????????????
        favoriteButton.setAttributedTitle(NSAttributedString(string: (favoriteButton.titleLabel?.text)!, attributes: Constants.buttonLabelAttributes), for: .normal)
        favoriteButton.layer.cornerRadius = Constants.defaultCornerRadius
    }
    
    func setNavigationBar() {
        if let navigationBarFrame = self.navigationController?.navigationBar.frame {
            // ????????????????????????
            let rouletteButton = UIBarButtonItem(image: UIImage(named: "roulette")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(tapRouletteButton))
            // ???????????????
            let settingButton = UIBarButtonItem(image: UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(tapSettingButton))
            // ???????????????????????????
            let titleTextField: UITextField = UITextField(frame: navigationBarFrame)
            titleTextField.backgroundColor = .white
            titleTextField.text = DataManager.dataManagerInstance.currentDataSet?.title
            titleTextField.placeholder = "?????????????????????"
            titleTextField.borderStyle = .roundedRect
            titleTextField.delegate = self
            
            self.navigationItem.rightBarButtonItem = rouletteButton
            self.navigationItem.leftBarButtonItem = settingButton
            self.navigationItem.titleView = titleTextField
        }
    }
    
    
    // MARK: - button action method
    @IBAction func tapAddItemButton(_ sender: Any) {
        let rouletteItemObj = RouletteitemObj()
        rouletteItemObj.color = Constants.selectColorArray[rouletteItemDataSet.dataSet.count % 25].hexString()
        
        rouletteItemDataSet.dataSet.append(rouletteItemObj)
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row:rouletteItemDataSet.dataSet.count-1, section: 0)], with: .automatic)
        self.tableView.endUpdates()
    }
    
    @IBAction func tapFavoriteButton(_ sender: Any) {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let selectFavoriteAction = UIAlertAction(title: "???????????????????????????", style: .default, handler: {(action: UIAlertAction!) in
            self.performSegue(withIdentifier: "toFavoriteViewSegue", sender: nil)
        })
        let addFavoriteAction = UIAlertAction(title: "????????????????????????", style: .default, handler: {(action: UIAlertAction!) in
            DataManager.dataManagerInstance.updateSetDataSet(dataSet: self.rouletteItemDataSet)
            
            let addDataSet = DataManager.dataManagerInstance.copyDataSet()
            RealmManager.realmManagerInstance.addRouletteDataSet(dataSet: addDataSet)
            
            let dialog = UIAlertController(title: "????????????????????????????????????", message: "", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        
        alertSheet.addAction(selectFavoriteAction)
        alertSheet.addAction(addFavoriteAction)
        alertSheet.addAction(cancelAction)
        
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    @objc func tapRouletteButton(_ sender: Any) {
        if rouletteItemDataSet.dataSet.count < 2 {
            let alertController = UIAlertController(title: "!!!Warning!!!",
                                                    message: "????????????????????????2?????????????????????",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            // ?????????????????????View???????????????????????????????????????
            closeKeyboard()
            // ????????????????????????????????????
            performSegue(withIdentifier: "toRouletteViewSegue", sender: nil)
        }
    }
    
    @objc func tapSettingButton(_ sender: Any) {
        closeKeyboard()
        // ????????????????????????????????????
        performSegue(withIdentifier: "toAppSettingViewSegue", sender: nil)
    }
    
    // MARK: - tableView DataSouce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rouletteItemDataSet.dataSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rouletteItemCell", for: indexPath) as! RouletteItemCell
        // ???????????????
        if let setColor = UserDefaults.standard.object(forKey: "backGroundColor") as? Data {
            let reloadColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(setColor) as? UIColor
            cell.contentView.backgroundColor = reloadColor
        } else {
            cell.contentView.backgroundColor = Constants.backGroundColorPalette.palette[0].color
        }
        cell.setValue(indexPath: indexPath, rouletteItemObj:rouletteItemDataSet.dataSet[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    
    // MARK: - tableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:"delete") { (ctxAction, view, completionHandler) in
            self.rouletteItemDataSet.dataSet.remove(at: indexPath.row)
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
    
    
    // MARK: - Notification Setting Method
    func registerNotification() {
        let center: NotificationCenter = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterNotification() {
        let center: NotificationCenter = NotificationCenter.default
        
        center.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    // MARK: - keyboard View Method
    @objc func keyboardWillShow(notification: Notification) -> () {
        //????????????????????????
        var keyboardFrame: CGRect = CGRect.zero
        if let userInfo = notification.userInfo {
            if let keyboard = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                keyboardFrame = keyboard.cgRectValue
                tableView.contentInset = UIEdgeInsets(top: 0,
                                                      left: 0,
                                                      bottom: keyboardFrame.height + Constants.cellHeight - (buttonAreaView.frame.height/2),
                                                      right: 0)
                tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                               left: 0,
                                                               bottom: keyboardFrame.height + Constants.cellHeight - (buttonAreaView.frame.height/2),
                                                               right: 0)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) -> () {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    // MARK: -tapGesture Method
    @objc func closeKeyboard() {
        self.view.endEditing(true)
        self.navigationItem.titleView?.endEditing(true)
    }
    
    
    // MARK: - UITextFieldDelegate method
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        rouletteItemDataSet.title = (navigationItem.titleView as! UITextField).text
    }
    
    
    // MARK: - RouletteItemCellDelegate method
    func textFieldShouldBeginEditing(cell: RouletteItemCell, textField: UITextField) {
    }
    
    func textFieldDidEndEditing(cell: RouletteItemCell, textField: UITextField) {
        let textFieldIndexPath = tableView.indexPathForRow(at: cell.center)
        let cellRow = textFieldIndexPath!.row
        
        if textField.tag == 1 {
            rouletteItemDataSet.dataSet[cellRow].rouletteItem = textField.text
        } else if textField.tag == 2 {
            rouletteItemDataSet.dataSet[cellRow].ratio = Int(textField.text!) ?? 1
        }
        
        rouletteItemDataSet.title = (navigationItem.titleView as! UITextField).text
    }
    
    func tapColorButton(button: UIButton) {
        performSegue(withIdentifier: "toColorSelectViewSegue", sender: button)
    }
    
    func doubleTapGestureAction(cell: RouletteItemCell) {
        if UserDefaults.standard.bool(forKey: "cheatFlg") == true {
            let tappedIndexPath = tableView.indexPath(for: cell)
            let tappedRow = tappedIndexPath?.row
            cheatItemIndex = tappedRow
        }
    }
    
    
    // MARK: - Segue method
    //??????????????????????????????
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let colorSelectVC = segue.destination as? ColorSelectVC { // ??????????????????????????????????????????
            if let button = sender as? UIButton {
                colorSelectVC.resultHandler = { selectColor in
                    button.backgroundColor = selectColor
                    self.rouletteItemDataSet.dataSet[button.tag].color = selectColor.hexString()
                }
            }
        }
        if let rouletteVC = segue.destination as? RouletteVC { // ??????????????????????????????????????????
            if let cheatIndex = self.cheatItemIndex {
                rouletteVC.cheatItemIndex = cheatIndex
            } else {
                rouletteVC.cheatItemIndex = 0
            }
            rouletteItemDataSet.title = (navigationItem.titleView as! UITextField).text == "" ? "??????????????????" : (navigationItem.titleView as! UITextField).text
            DataManager.dataManagerInstance.updateSetDataSet(dataSet: rouletteItemDataSet)
        }
        
        if segue.destination is AppSettingVC { // ?????????????????????????????????
            DataManager.dataManagerInstance.updateSetDataSet(dataSet: rouletteItemDataSet)
        }
        
        if segue.destination is FavoriteVC { // ??????????????????????????????????????????
            DataManager.dataManagerInstance.updateSetDataSet(dataSet: rouletteItemDataSet)
        }
    }
}
