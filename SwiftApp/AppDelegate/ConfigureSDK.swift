//
//  ConfigureSDK.swift
//  SwiftApp
//
//  Created by fly on 2022/7/20.
//

import Foundation
import UIKit
import IQKeyboardManager

class ConfigureSDK
{
    class func initSDK(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    {
        initHUD()
        initKeyboardManager()
    }
}



// MARK: - initSDK

extension ConfigureSDK
{
    private class func initHUD()
    {
        //风格颜色
        SVProgressHUD.setDefaultStyle(.dark)
        //膜的类型
        SVProgressHUD.setDefaultMaskType(.none)
        //设置最小尺寸
        SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 0))
        //设置最短消失时间
        SVProgressHUD.setMinimumDismissTimeInterval(3)
        //设置文字和转圈的颜色
        SVProgressHUD.setForegroundColor(UIColor.white)
        //设置底座view的颜色
        SVProgressHUD.setBackgroundColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6))
        //膜的颜色（需要把膜的类型设置成Custom才会生效）
        SVProgressHUD.setBackgroundLayerColor(UIColor.init(white: 0, alpha: 0.4))
    }
    
    private class func initKeyboardManager()
    {
        let keyboardManager = IQKeyboardManager.shared()
        
        //是否启用，默认YES
        keyboardManager.isEnabled = true
        
        //设置键盘与文本字段的距离，不能小于零，默认值为10
        keyboardManager.keyboardDistanceFromTextField = 10;
        
        //是否启用工具栏，默认YES
        keyboardManager.isEnableAutoToolbar = true;
        
        //是否点击空白收键盘，默认NO
        keyboardManager.shouldResignOnTouchOutside = true;
        
        //把工具栏上的"Done"按钮改成"完成"
        keyboardManager.toolbarDoneBarButtonItemText = "完成";
        
        //如果需要，重新加载布局 (如果用户明确进行了任何外部更改，则刷新textField/textView位置。)
        keyboardManager.reloadLayoutIfNeeded()
        
        
        /**
         如果需要实现多个输入框，点击下一项切换输入框，
         1.需要在那个控制器添加一个成员变量：IQKeyboardReturnKeyHandler * _returnKeyHander;
         2.然后在viewWillAppear方法里执行一句：_returnKeyHander = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
         */
    }
}


