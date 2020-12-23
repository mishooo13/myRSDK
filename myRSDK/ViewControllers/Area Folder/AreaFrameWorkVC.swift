//
//  AreaVC.swift
//  Prego
//
//  Created by Other Logic on 12/1/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol AreaDelegate {
    func dismissAreaDelegate() -> Void
    func passArea(area: AreaClass) -> Void
    func keyboardDetect(isOpne: Bool) -> Void
}

protocol DetectLocationDelegate {
    func passArea(area: AreaClass, areaObjectList: [AreaClass]) -> Void
}



class AreaFrameWorkVC: UIViewController {
    
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var searchEditText: UITextField!
    
    var areaObjectList: [AreaClass] = []
    var searchAreaObjectList: [AreaClass] = []
    
    var delegate: AreaDelegate?
    var detectDelegate: DetectLocationDelegate?
    
    var ifFromDetect: Bool = false
    let areaNib = "AreaCell"
    
    var detectCallback : ((_ area: AreaClass,_ areaObjectList: [AreaClass])->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setNIBs()
        getAreas()
        
        detectKeyboard()
    }
    
    public init() {
        super.init(nibName: "AreaFrameWorkVC", bundle: Bundle(for: AreaFrameWorkVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func dismissAction(_ sender: Any) {
        backAgain()
        //delegate?.dismissAreaDelegate()
    }
    
    func backAgain(){
        self.view.endEditing(true)
        searchAreaObjectList = areaObjectList
        searchEditText.text = ""
        self.mTableView.reloadData()
    }
    
    func detectKeyboard(){
        searchEditText.addTarget(self, action: #selector(AreaFrameWorkVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
       NotificationCenter.default.addObserver(self,
       selector: #selector(self.keyboardNotification(notification:)),
       name: UIResponder.keyboardWillChangeFrameNotification,
       object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                delegate?.keyboardDetect(isOpne: false)
            } else {
                delegate?.keyboardDetect(isOpne: true)
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("tttttext \(String(describing: textField.text))")
        
        guard let searchText = textField.text else {
            searchAreaObjectList = areaObjectList
            self.mTableView.reloadData()
            return
        }
        
        searchAreaObjectList.removeAll()
        
        if searchText.isEmpty {
            searchAreaObjectList = areaObjectList
            self.mTableView.reloadData()
        }else{
            areaObjectList.forEach { (area) in
                if APPLanguage() == Config.English {
                    guard let title = area.areaNameEn else{
                        return
                    }
                    if title.lowercased().contains(searchText.lowercased()) {
                        searchAreaObjectList.append(area)
                    }
                }else{
                    guard let title = area.areaNameAr else{
                        return
                    }
                    if title.lowercased().contains(searchText.lowercased()) {
                        searchAreaObjectList.append(area)
                    }
                }
            }
            self.mTableView.reloadData()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //handle appearing of keyboard here
        print("reponse opeeeeeen")
        delegate?.keyboardDetect(isOpne: true)
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //handle dismiss of keyboard here
        print("reponse cloooose")
        delegate?.keyboardDetect(isOpne: false)
    }
    
    func setUI(){
        //Utilits.cornerLeftRight(view: mView)
        
        mTableView.separatorStyle = .none
        mTableView.rowHeight = UITableView.automaticDimension
        mTableView.estimatedRowHeight = 250
        
        searchEditText.delegate = self
        
        if ifFromDetect {
            dismissBtn.isHidden = true
        }else{
            dismissBtn.isHidden = false
        }
    }
    
    func setNIBs(){
        mTableView?.register(UINib(nibName: areaNib, bundle: frameworkBundle), forCellReuseIdentifier: areaNib)
    }
    
    func getAreas(){
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "loading".getLocalizedValue()
        hud.show(in: self.view, animated: true)
        
        LoginAPI.areasAPI(view: self.view) { (error, success, model) in
            hud.dismiss(animated: true)
            if error != nil || !success{
                return
            }
            guard let data = model?.data else {
                return
            }
            guard let list = data.areas else {
                return
            }
            self.areaObjectList = list
            self.searchAreaObjectList = list
            self.mTableView.reloadData()
        }
    }
}


extension AreaFrameWorkVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension AreaFrameWorkVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchAreaObjectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AreaCell = mTableView.dequeueReusableCell(withIdentifier: areaNib, for: indexPath) as! AreaCell
        cell.selectionStyle = .none
        if APPLanguage() == Config.English {
            if let title = searchAreaObjectList[indexPath.row].areaNameEn {
                cell.areaLabel.text = title
            }
        }else{
            if let title = searchAreaObjectList[indexPath.row].areaNameAr {
                cell.areaLabel.text = title
            }
        }
        
        if let selectedArea = DefaultManager.getAreaDefault() {
            if let sid = selectedArea.id, let id = searchAreaObjectList[indexPath.row].id {
                if sid == id {
                    cell.checkedImage.isHidden = false
                }else{
                    cell.checkedImage.isHidden = true
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if ifFromDetect {
            detectDelegate?.passArea(area: searchAreaObjectList[indexPath.row], areaObjectList: areaObjectList)
            self.detectCallback?(searchAreaObjectList[indexPath.row], areaObjectList)
        }else{
            delegate?.passArea(area: searchAreaObjectList[indexPath.row])
            backAgain()
        }
    }
    
    
}
