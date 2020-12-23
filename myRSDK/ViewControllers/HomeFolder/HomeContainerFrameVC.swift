//
//  HomeContainerFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/10/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class HomeContainerFrameVC: UIViewController {

    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var sideBarView: UIView!
    @IBOutlet weak var sideBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeBtn: UIButton!
    
    var isOpen: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openCloseSideBar), name: .didSideBar, object: nil)
        
        //addAreaContainer()
        addContainer(view: homeView, containerController: HomeFrameVC())
        addContainer(view: sideBarView, containerController: SideBarFrameVC())
    }
    
    func addAreaContainer(){
        // add container

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        homeView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: homeView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: homeView.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: homeView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: homeView.bottomAnchor, constant: 0),
        ])

        // add child view controller view to container

        let controller = HomeFrameVC()
        
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
    
    public init() {
        super.init(nibName: "HomeContainerFrameVC", bundle: Bundle(for: HomeContainerFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @IBAction func homeAction(_ sender: Any) {
        openCloseProcess()
    }
    
    @objc func openCloseSideBar(){
        
        openCloseProcess()
    }
    
    func openCloseProcess(){
        if isOpen {
            isOpen = false

            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.sideBarConstraint.constant = 0
                self.homeBtn.isHidden = true
                self.view.layoutIfNeeded()
            }) { (success) in
                
            }
        }else{
            isOpen = true
            //self.sideBarView.isHidden = false
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.sideBarConstraint.constant = self.view.bounds.width * 0.80
                self.homeBtn.isHidden = false
                self.view.layoutIfNeeded()
            }) { (success) in }
        }
    }

}


