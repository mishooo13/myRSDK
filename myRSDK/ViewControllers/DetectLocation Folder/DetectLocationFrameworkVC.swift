//
//  DetectLocationVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/9/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit
import DropDown
import JGProgressHUD

class DetectLocationFrameworkVC: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var downImage: UIImageView!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var startedBtn: UIButton!
    
    @IBOutlet weak var topConstraintLocation:NSLayoutConstraint!
    @IBOutlet weak var locationView:UIView!
    
    let dropDown = DropDown()
    var areaList: [String] = []
    var areaObjectList: [AreaClass] = []
    
    let resturantChainSegue = "toResturantChain"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        //Reset area defalut
        DefaultManager.removeAreaDeafult()
        
        self.addAreaContainer()
        //addContainer(view: locationView, containerController: AreaFrameWorkVC())

        setUI()
        getLocation()
        hideLocationView()
        getImageAPI()
    }
    
    public init() {
        super.init(nibName: "DetectLocationFrameworkVC", bundle: Bundle(for: DetectLocationFrameworkVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAreaContainer(){
        // add container

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        locationView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: locationView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: locationView.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: locationView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 0),
        ])

        // add child view controller view to container

        let controller = AreaFrameWorkVC()
        //controller.detectDelegate = self
        controller.ifFromDetect = true
        controller.detectCallback = { area, list in
            self.passArea(area: area, areaObjectList: list)
        }
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        controller.didMove(toParent: self)
    }
    
    func getLocation(){
        if let selectedItem = DefaultManager.getAreaDefault() {
            if APPLanguage() == Config.English {
                
                guard let title = selectedItem.areaNameEn else {
                    return
                }
                self.areaLabel.text = title
            }else{
                
                guard let title = selectedItem.areaNameAr else {
                    return
                }
                self.areaLabel.text = title
            }
        }
    }
    
    func getImageAPI(){
        ProfileAPI.locationAPI { (error, success, model) in
            if error != nil || !success{
                return
            }
            guard let data = model?.data else {
                return
            }
            guard let setting = data.settings else {
                return
            }
            if setting.isEmpty {
                return
            }
            guard let value = setting[0].value else {
                return
            }
            ImagesManager.setImage(url: value, image: self.backgroundImage)
        }
    }
    
    func hideLocationView(){
        self.topConstraintLocation.constant = self.locationView.frame.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //getAreas()
    }
    
    func setUI(){
        Utilits.cornerLeftRight(view: subView)
        areaView.layer.borderWidth = 1.0
        areaView.layer.borderColor = UIColor.white.cgColor
        
        downImage.image = downImage.image?.withRenderingMode(.alwaysTemplate)
        downImage.tintColor = UIColor.white
    }
    
    func getAreas(){
        if !Connectivity.isConnectedToInternet {
            AlertManager.showWrongAlertWithMessage(on: self, message: "internet_failed".getLocalizedValue())
            return
        }
        //showLoadingView(on: subView)
        
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
            list.forEach({ (item) in
                if self.APPLanguage() == Config.English {
                    if let title = item.areaNameEn {
                        self.areaList.append(title)
                    }
                }else{
                    if let title = item.areaNameAr {
                        self.areaList.append(title)
                    }
                }
            })
            self.areaObjectList = list
            self.setDropDown(on: self.dropDownBtn, list: self.areaList)
        }
    }
    
    func setDropDown(on View: UIView ,list: [String]){
        Utilits.configureDropDown(dropDown: dropDown, dropDownWidth: dropDownBtn.frame.width)
        dropDown.anchorView = View
        dropDown.dataSource = list
        dropDown.selectionAction = { (index: Int, item: String) in
            self.areaLabel.text = list[index]
            if !self.areaObjectList.isEmpty {
               DefaultManager.saveAreaDefault(value: self.areaObjectList[index])
            }
        }
        if let selectedItem = DefaultManager.getAreaDefault() {
            for (index, item) in areaObjectList.enumerated() {
                if APPLanguage() == Config.English {
                    if let itemID = item.id, let selectedItemId = selectedItem.id, let title = selectedItem.areaNameEn {
                        print("nnnn \(itemID)  \(selectedItemId)")
                        if itemID == selectedItemId {
                            self.dropDown.selectRow(index)
                            self.areaLabel.text = title
                        }
                    }
                }else{
                    if let itemID = item.id, let selectedItemId = selectedItem.id, let title = selectedItem.areaNameAr {
                        print("nnnn \(itemID)  \(selectedItemId)")
                        if itemID == selectedItemId {
                            self.dropDown.selectRow(index)
                            self.areaLabel.text = title
                        }
                    }
                }
            }
        }
        
    }

    @IBAction func dorpDownAction(_ sender: Any) {
        //dropDown.show()
        locationView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.topConstraintLocation.constant = 20
            self.view.layoutIfNeeded()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAreaSegue" {
            let embedVC = segue.destination as! AreaFrameWorkVC
            embedVC.ifFromDetect = true
            embedVC.detectDelegate = self
        }else if segue.identifier == resturantChainSegue {
            let embedVC = segue.destination as! ReasturantChainFrameVC
            embedVC.areaList = areaList
            embedVC.areaObjectList = areaObjectList
        }
    }
    
    @IBAction func startedAction(_ sender: Any) {
        if DefaultManager.getAreaDefault() != nil {
            //NavigationManager.toReasturantChain(self)
            
            getReasturants()
        }else{
            showToast(message: "area_choose".getLocalizedValue(), controller: self)
        }
    }
    
    
    func getReasturants(){
        guard let areaID = Utilits.getSelectedAreaID() else {
            return
        }
        showLoadingView(on: self.view)
        MenuAPI.reasturantChain(areaID: areaID, view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success {
                return
            }
            guard let data = model?.data, let list = data.restaurants else {
                return
            }
            self.checkIfOnlyReasturant(chains: list)
            print("sssize \(list.count)")
            
        }
    }
    func checkIfOnlyReasturant(chains: [Chain]){
        if DefaultManager.getIsMultiChain(){
            performSegue(withIdentifier: resturantChainSegue, sender: nil)
        }else{
            if chains.isEmpty{
                return
            }
            DefaultManager.saveReasrturantDefault(value: chains[0])
            NavigationManager.toHome(self)
        }
        
        
        /*if chains.count == 1 {
            DefaultManager.saveReasrturantDefault(value: chains[0])
            NavigationManager.toHome(self)
        }else{
            performSegue(withIdentifier: resturantChainSegue, sender: nil)
        }*/
    }

}


extension DetectLocationFrameworkVC: DetectLocationDelegate {
    func passArea(area: AreaClass, areaObjectList: [AreaClass]) {
        DefaultManager.saveAreaDefault(value: area)
        self.areaObjectList = areaObjectList
        setAreaList(list: areaObjectList)
        
        if APPLanguage() == Config.English {
            guard let title = area.areaNameEn else {
                return
            }
            self.areaLabel.text = title
        }else{
            guard let title = area.areaNameAr else {
                return
            }
            self.areaLabel.text = title
        }
        
        locationView.isHidden = true
    }
    
    func setAreaList(list: [AreaClass]){
        list.forEach({ (item) in
            if self.APPLanguage() == Config.English {
                if let title = item.areaNameEn {
                    self.areaList.append(title)
                }
            }else{
                if let title = item.areaNameAr {
                    self.areaList.append(title)
                }
            }
        })
    }
}
