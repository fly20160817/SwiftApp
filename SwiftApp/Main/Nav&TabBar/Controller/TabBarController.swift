//
//  TabBarController.swift
//  SwiftApp
//
//  Created by fly on 2022/7/19.
//

import UIKit

class TabBarController: UITabBarController {

    private lazy var dataList: NSArray = {
        let path = Bundle.main.path(forResource: "Tabbar", ofType: "plist")
        return NSArray.init(contentsOfFile: path!)!
    }()
    
    //private lazy var vcNames = [ "HomeViewController", "MessageViewController", "MyViewController" ]
    private lazy var vcClassArray: Array<UIViewController.Type> = [ HomeViewController.self, MessageViewController.self, MyViewController.self ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initUI()
        configViewControllers()
    }

}



// MARK: - UI

extension TabBarController
{
    func initUI()
    {
        // 设置tabBar是否半透明 (YES：标签栏半透明，内容会延伸到tabBar下方；NO：标签栏不透明，内容不会延伸到tabBar下方)
        // 设置半透明时，如果tabBar下面的是 scrollView，设置 scrollView.contentInsetAdjustmentBehavior = .automatic，内容会自动往上偏移，让内容不会被tabBar遮挡。
        tabBar.isTranslucent = true
        
        
        if #available(iOS 13.0, *)
        {
            let barAppearance  = UITabBarAppearance()
            //bar的背景颜色
            barAppearance.backgroundColor = UIColor.white
            //底下线的颜色
            barAppearance.shadowColor = colorHex("ECECEC")
            
            //设置底部按钮的字体和颜色
            let normalDic = [ NSAttributedString.Key.font : FONT_R(10), NSAttributedString.Key.foregroundColor : colorHex("#8E8E93") ]
            let selectedDic = [ NSAttributedString.Key.font : FONT_S(10), NSAttributedString.Key.foregroundColor : colorHex("#04A1FD") ]
            barAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalDic
            barAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedDic
            
            tabBar.standardAppearance = barAppearance
            if #available(iOS 15.0, *)
            {
                tabBar.scrollEdgeAppearance = barAppearance
            }
        }
        else
        {
            //bar的背景颜色
            tabBar.barTintColor = UIColor.white
            //底下线的颜色
            tabBar.shadowImage = UIImage.init(color: colorHex("#ECECEC"), size: CGSize(width: SCREEN_WIDTH, height: 1))
            
            
            //设置底部按钮的字体和颜色 （字体只能在UIControlStateNormal状态设置，在其他状态设置均不生效。）
            let normalDic = [ NSAttributedString.Key.font : FONT_R(10), NSAttributedString.Key.foregroundColor : colorHex("#8E8E93") ]
            let selectedDic = [ NSAttributedString.Key.font : FONT_S(10), NSAttributedString.Key.foregroundColor : colorHex("#04A1FD") ]
            
            tabBarItem.setTitleTextAttributes(normalDic, for: .normal)
            tabBarItem.setTitleTextAttributes(selectedDic, for: .selected)
        }
    }
    
    func configViewControllers()
    {
        var vcArray = [UIViewController]()
        
        for i in 0 ..< vcClassArray.count
        {
            /*
            Swift中新增了一个叫做命名空间的概念
            作用: 避免重复
            不通项目中的命名空间是不一样的, 默认情况下命名空间的名称就是当前项目的名称
            正是因为Swift可以通过命名空间来解决重名的问题, 所以在做Swift开发时尽量使用cocoapods来集成三方框架, 这样可以有效的避免类名重复
            正是因为Swift中有命名空间, 所以通过一个字符串来创建一个类和OC中也不太一样了, OC中可以直接通过类名创建一个类, 而Swift中如果想通过类名来创建一个类必须加上命名空间
            */
            
            
           
            /*
             获取命名空间 (项目名称)
             
             
             infoDictionary方法返回的是可选项字典，可选项不能直接取值，要用 !(强制解包) 或 ?(可选链)， 因为怕字典为nil，不能用 ! 强制解包，所以要用 ?
             
             字典取出来的值都是可选项，不要用 as! 强制转换成String，不安全，
             使用可选项绑定，如果不为nil就自动解包，并把值赋给一个临时的变量name，并返回true，否则返回false
             
             配合使用 guard else 语句，如果返回false则提前退出
             */
            
            
//            let name: String = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
//            let vcName = vcNames[i]
//
//            let typeClass = NSClassFromString(name + "." + vcName) as! UIViewController.Type
//            let vc = typeClass.init()
            
            let vc = vcClassArray[i].init()
            
            let dic: Dictionary = dataList[i] as! Dictionary<String, String>
            
            let nav = NavigationController.init(rootViewController: vc)
            nav.tabBarItem.title = dic["title"]
            nav.tabBarItem.image = UIImage.init(namedWithOriginal: dic["normal"]!)
            nav.tabBarItem.selectedImage = UIImage.init(namedWithOriginal: dic["selected"]!)
            vcArray.append(nav)
        }
        
        viewControllers = vcArray
    }
}
