//
//  NavigationController.swift
//  SwiftApp
//
//  Created by fly on 2022/7/18.
//

import UIKit

//只有AnyObject类型，才能遵守这个协议
protocol NavigationControllerDelegate: AnyObject {
    
    /**点击了返回按钮 (实现了这个代理，返回功能就失效了，需要自己来实现)*/
    func navigationController(didClickBackAt nav: NavigationController) -> Void
}



class NavigationController: UINavigationController {

    //用weak修饰，解决循环引用的问题
    //在swift中遵守protocol的类型有很多，其中有些类型不支持weak修饰，比如struct。所以定义协议的时候，需要限制protocol的类型遵守。
    weak public var fly_delegate: NavigationControllerDelegate?
    
    /// 是否显示导航栏下面的线（默认NO）
    public var showLine: Bool = false {
        didSet{
            if #available(iOS 13.0, *)
            {
                navigationBar.scrollEdgeAppearance?.shadowColor = showLine ? colorHex("#EAEAEA") : UIColor.clear
                navigationBar.standardAppearance.shadowColor = showLine ? colorHex("#EAEAEA") : UIColor.clear
            }
            else
            {
                navigationBar.shadowImage = UIImage.init(color: showLine ? colorHex("#EAEAEA") : UIColor.clear, size: CGSize(width: SCREEN_WIDTH, height: 1))
            }
        }
    }
    
    
    /// bar的默认背景颜色
    public var defaultBarColor: UIColor = colorHex("#FFFFFF")
    
    /// 默认标题颜色
    public var defaultTitleColor: UIColor = colorHex("#333333")
    
    /// 默认标题字体
    public var defaultTitleFont: UIFont = FONT_M(16)
    
    /// 默认返回箭头的图片名字
    public var defaultArrowImageName: String = "icon_return"
    
    
    
    /** 提供几个样式属性，如果哪个页面设计的不一样，可以单独设置 **/
    
    /// bar的背景颜色
    public var barColor: UIColor? {
        didSet{
            
            if #available(iOS 13.0, *)
            {
                navigationBar.scrollEdgeAppearance?.backgroundColor = barColor
                navigationBar.standardAppearance.backgroundColor = barColor
            }
            else
            {
                navigationBar.barTintColor = barColor
            }
        }
    }
    
    /// 标题颜色
    public var titleColor: UIColor? {
        
        didSet{
            
            if #available(iOS 13.0, *)
            {
                var barAppearance = navigationBar.standardAppearance
                
                var dic = barAppearance.titleTextAttributes
                dic[NSAttributedString.Key.foregroundColor] = titleColor
                barAppearance.titleTextAttributes = dic
                
                navigationBar.scrollEdgeAppearance = barAppearance
                navigationBar.standardAppearance = barAppearance
            }
            else
            {
                var dic = navigationBar.titleTextAttributes
                dic?[NSAttributedString.Key.foregroundColor] = titleColor
                navigationBar.titleTextAttributes = dic
            }
        }
    }
    
    /// 标题字体
    public var titleFont: UIFont? {
        
        didSet{
            
            if #available(iOS 13.0, *)
            {
                var barAppearance = navigationBar.standardAppearance
                
                var dic = barAppearance.titleTextAttributes
                dic[NSAttributedString.Key.font] = titleFont
                barAppearance.titleTextAttributes = dic
                
                navigationBar.scrollEdgeAppearance = barAppearance
                navigationBar.standardAppearance = barAppearance
            }
            else
            {
                var dic = navigationBar.titleTextAttributes
                dic?[NSAttributedString.Key.font] = titleFont
                navigationBar.titleTextAttributes = dic
            }
            
        }
    }
    
    /// 返回箭头的图片名字
    public var arrowImageName: String? {
        
        didSet{
            
            viewControllers.last?.navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: arrowImageName!, target: self, action: #selector(backAction))
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        initUI()
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool)
    {
        if viewControllers.count > 0
        {
            //自定义返回按钮
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: defaultArrowImageName, target: self, action: #selector(backAction))
            
            //隐藏底部tabBer
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
}



// MARK: - UI

private extension NavigationController
{
    func initUI()
    {
        //设置系统的滑动手势代理为自己
        interactivePopGestureRecognizer?.delegate = self

        //设置导航栏不透明，内容就会自动从导航栏下面开始
        navigationBar.isTranslucent = false;


        if #available(iOS 13.0, *)
        {
            let barAppearance = UINavigationBarAppearance()
            //bar的背景颜色
            barAppearance.backgroundColor = defaultBarColor
            //底下线的颜色
            barAppearance.shadowColor = UIColor.clear

            //设置导航条标题的字体、颜色
            let dic = [ NSAttributedString.Key.font : defaultTitleFont, NSAttributedString.Key.foregroundColor : defaultTitleColor ]
            barAppearance.titleTextAttributes = dic

            navigationBar.scrollEdgeAppearance = barAppearance
            navigationBar.standardAppearance = barAppearance
        }
        else
        {
            //bar的背景颜色
            navigationBar.barTintColor = defaultBarColor

            //底下线的颜色
            navigationBar.shadowImage = UIImage.init(color: UIColor.clear, size: CGSize(width: SCREEN_WIDTH, height: 1))

            //设置导航条标题的字体、颜色
            let dic = [ NSAttributedString.Key.font : defaultTitleFont, NSAttributedString.Key.foregroundColor : defaultTitleColor ]
            navigationBar.titleTextAttributes = dic
        }
    }
}




// MARK: - event handler

private extension NavigationController
{
    @objc func backAction()
    {
        if ( fly_delegate != nil )
        {
            fly_delegate?.navigationController(didClickBackAt: self)
            
            //执行完代理就解除，不然外界在代理方法里执行了返回，控制器被释放，导致fly_delegate指向野指针，导致闪退
            fly_delegate = nil
        }
        else
        {
            popViewController(animated: true)
        }
        
    }
}



// MARK: - Protocal

extension NavigationController: UIGestureRecognizerDelegate
{
    //手势是否触发
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        //根控制器不触发手势
        return children.count > 1
    }
}


