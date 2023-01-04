//
//  BaseViewController.swift
//  SwiftApp
//
//  Created by fly on 2022/7/18.
//

//如果不同的项目有什么要修改的，在这个类里改，不去动FLYViewController


import UIKit

class BaseViewController: FLYViewController {

    public var showNavLine: Bool = true
    
    
    /** 下面的属性导航栏类已经设置了，如果哪个页面设计的不一样，可以单独设置 **/
    
    /// 导航栏bar的背景颜色
    public var navBarColor: UIColor?
    
    /// 导航栏标题颜色
    public var navTitleColor: UIColor?
    
    /// 导航栏标题字体
    public var navTitleFont: UIFont?
    
    /// 导航栏返回箭头的图片名字
    public var navArrowImageName: String?
    
    
    
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
        
        
        if (navBarColor != nil)
        {
            nav.barColor = navBarColor!
        }
        
        if (navTitleColor != nil)
        {
            nav.titleColor = navTitleColor!
        }
        
        if (navTitleFont != nil)
        {
            nav.titleFont = navTitleFont!
        }
        
        if (navArrowImageName != nil)
        {
            nav.arrowImageName = navArrowImageName!
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let nav = navigationController as? NavigationController else
        {
            return
        }
        
        
        /** 因为只是为这个页面单独设置的，所以这个页面消失的时候要还原以前的设置。**/
        
        if (navBarColor != nil)
        {
            nav.barColor = nav.defaultBarColor
        }
        
        if (navTitleColor != nil)
        {
            nav.titleColor = nav.defaultTitleColor
        }
        
        if (navTitleFont != nil)
        {
            nav.titleFont = nav.defaultTitleFont
        }
    }

}
