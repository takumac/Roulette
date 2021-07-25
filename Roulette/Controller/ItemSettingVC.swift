//
//  ItemSettingVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/04/06.
//

import UIKit
import MaterialComponents

class ItemSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, RouletteItemCelldelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: MDCRaisedButton!
    
    
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
        // AutoLayout
        addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        addButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        addButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        addButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let dataSet = DataManager.dataManagerInstance.currentDataSet {
            rouletteItemDataSet = dataSet
        } else {
            rouletteItemDataSet = RouletteItemDataSet()
        }
        // 背景色設定
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
        registerNotification()
        
        // キーボード外(TextField等の部品を除く)をタップしたらキーボードを閉じるように設定
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
        // ナビゲーションバーの設定
        setTitleTextField()
        // tableViewの設定
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RouletteItemCell", bundle: nil), forCellReuseIdentifier: "rouletteItemCell")
        // 項目追加ボタンの設定
        addButton.setAttributedTitle(NSAttributedString(string: (addButton.titleLabel?.text)!, attributes: Constants.buttonLabelAttributes), for: .normal)
    }
    
    func setTitleTextField() {
        if let navigationBarFrame = self.navigationController?.navigationBar.frame {
            let titleTextField: UITextField = UITextField(frame: navigationBarFrame)
            titleTextField.backgroundColor = .white
            titleTextField.placeholder = "タイトルを入力"
            titleTextField.borderStyle = .roundedRect
            self.navigationItem.titleView = titleTextField
        }
    }
    
    
    // MARK: - button action method
    @IBAction func tapAddItemButton(_ sender: Any) {
        let rouletteItemObj = RouletteitemObj()
        rouletteItemObj.color = Constants.selectColorArray[rouletteItemDataSet.dataSet.count % 25]
        
        rouletteItemDataSet.dataSet.append(rouletteItemObj)
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row:rouletteItemDataSet.dataSet.count-1, section: 0)], with: .automatic)
        self.tableView.endUpdates()
    }
    
    @IBAction func tapRouletteButton(_ sender: Any) {
        if rouletteItemDataSet.dataSet.count < 2 {
            let alertController = UIAlertController(title: "!!!Warning!!!",
                                                    message: "ルーレット項目は2つ以上必要です",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            // 画面上の全てのViewに対するフォーカスを外す。
            // こうすることで、最後に編集していたルーレット項目の内容を次画面に渡す配列に反映できる。
            closeKeyboard()
            // ルーレット画面へ遷移する
            rouletteItemDataSet.title = (navigationItem.titleView as! UITextField).text
            performSegue(withIdentifier: "toRouletteViewSegue", sender: nil)
        }
    }
    
    @IBAction func tapSettingButton(_ sender: Any) {
        closeKeyboard()
        // アプリ設定画面へ遷移する
        performSegue(withIdentifier: "toAppSettingViewSegue", sender: nil)
    }
    
    // MARK: - tableView DataSouce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rouletteItemDataSet.dataSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rouletteItemCell", for: indexPath) as! RouletteItemCell
        // 背景色設定
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
        //キーボードを取得
        var keyboardFrame: CGRect = CGRect.zero
        if let userInfo = notification.userInfo {
            if let keyboard = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                keyboardFrame = keyboard.cgRectValue
                tableView.contentInset = UIEdgeInsets(top: 0,
                                                      left: 0,
                                                      bottom: keyboardFrame.height + Constants.cellHeight - (addButton.frame.height/2),
                                                      right: 0)
                tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                               left: 0,
                                                               bottom: keyboardFrame.height + Constants.cellHeight - (addButton.frame.height/2),
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
    
    
    // MARK: - RouletteItemCellCellDelegate method
    func textFieldShouldBeginEditing(cell: RouletteItemCell, textField: UITextField) {
    }
    
    func textFieldDidEndEditing(cell: RouletteItemCell, textField: UITextField) {
        let textFieldIndexPath = tableView.indexPathForRow(at: cell.center)
        let cellRow = textFieldIndexPath!.row
        
        if textField.tag == 1 {
            rouletteItemDataSet.dataSet[cellRow].rouletteItem = textField.text
        } else if textField.tag == 2 {
            rouletteItemDataSet.dataSet[cellRow].ratio = Int(textField.text!)
        }
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
    //画面遷移時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let colorSelectVC = segue.destination as? ColorSelectVC { // 遷移先がカラー選択画面の場合
            if let button = sender as? UIButton {
                colorSelectVC.resultHandler = { selectColor in
                    button.backgroundColor = selectColor
                    self.rouletteItemDataSet.dataSet[button.tag].color = selectColor
                }
            }
        }
        if let rouletteVC = segue.destination as? RouletteVC { // 遷移先がルーレット画面の場合
            if let cheatIndex = self.cheatItemIndex {
                rouletteVC.cheatItemIndex = cheatIndex
            } else {
                rouletteVC.cheatItemIndex = 0
            }
            rouletteItemDataSet.title = (navigationItem.titleView as! UITextField).text == "" ? "タイトルなし" : (navigationItem.titleView as! UITextField).text
            DataManager.dataManagerInstance.updateSetDataSet(dataSet: rouletteItemDataSet)
        }
        
        if segue.destination is AppSettingVC { // 遷移先が設定画面の場合
            rouletteItemDataSet.title = (navigationItem.titleView as! UITextField).text
            DataManager.dataManagerInstance.updateSetDataSet(dataSet: rouletteItemDataSet)
        }
    }
}
