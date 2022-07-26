//
//  BaseViewController.swift
//  SwiftApp
//
//  Created by fly on 2022/7/18.
//

//如果不同的项目有什么要修改的，在这个类里改，不去动FLYViewController


import UIKit

class BaseViewController: FLYViewController {

    var showNavLine: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        view.backgroundColor = colorHex("#FAFBFC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let nav = navigationController as? NavigationController else
        {
            return
        }
        nav.showLine = showNavLine
    }

}
