//
//  Common.swift
//  SwiftApp
//
//  Created by fly on 2022/7/18.
//

import UIKit
import SwiftUI

public let SCREEN_WIDTH = UIScreen.main.bounds.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.height
//状态栏高度
public let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.height
//导航栏高度
public let NAVBAR_HEIGHT = UINavigationController().navigationBar.height
//状态栏高度 + 导航栏高度
public let STATUSADDNAV_HEIGHT = STATUSBAR_HEIGHT + NAVBAR_HEIGHT
//tabber高度
public let TABBER_HEIGHT = UITabBarController().tabBar.frame.height

//安全距离底部的高度
public let SAFE_BOTTOM = FLYTools.safeAreaInsets().bottom



//除了正常的打印，还添加了三个额外参数，并且设置了默认值，顺便打印出这三个参数可以更好的定位代码
//#file所在的文件  #line所在的行数  #function所在的函数
public func print<T>(_ msg: T,
            file: NSString = #file,
            line: Int = #line,
            fn: String = #function)
{
//只有Debug模式才执行打印
#if DEBUG
    //lastPathComponent获取最后一段路径名
    let prefix = "\(file.lastPathComponent)_\(line)_\(fn):"
    print(prefix, msg)
#endif
}



// 延迟执行
// 封装一个方法，传一个时间秒参数，和需要执行的任务 （异步执行需要返回这个任务item，外界可以拿到这个item执行取消任务）
//在 func 前面加个 @discardableResult，可以消除：函数调用后返回值未使用的警告
@discardableResult public func delay(_ seconds: Double, _ block: @escaping () -> Void) -> DispatchWorkItem {
    
    let item = DispatchWorkItem(block: block)
    //asyncAfter延迟执行  deadline:执行的时间(现在的时间+延迟多少秒)  execute:执行的任务
    //把 main 换成 global() 就是子线程延迟执行
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
    
    return item
}



public func RBGColor(r: Int, g: Int, b: Int, a: CGFloat) -> UIColor
{
    return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
}

//随机颜色
public func RBGColor_ARC4() -> UIColor
{
    RBGColor(r: Int(arc4random_uniform(255)), g: Int(arc4random_uniform(255)), b: Int(arc4random_uniform(255)), a: 1)
}



public func imageName(_ name: String) -> UIImage?
{
    return UIImage.init(named: name)
}

public func colorHex(_ hex: String) -> UIColor
{
    return UIColor.init(hexString: hex)
}


// APP名称
public let appName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
// Bundle Identifier
public let appBundleId: String = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
// 项目版本号
public let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
// 项目的build版本号
public let appBuild: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String


// 设备名字（用户自定义的名字）
public let deviceName: String = UIDevice.current.name
// 设备的系统版本
public let deviceVersion: String = UIDevice.current.systemVersion



// 苹方-简 常规体
private let PFSCR = "PingFangSC-Regular"
// 苹方-简 中黑体
private let PFSCM = "PingFangSC-Medium"
// 苹方-简 中粗体
private let PFSCS = "PingFangSC-Semibold"
// 苹方-简 细体
private let PFSCL = "PingFangSC-Light"
// 苹方-简 极细体
private let PFSCU = "PingFangSC-Ultralight"
// 苹方-简 纤细体
private let PFSCT = "PingFangSC-Thin"

public func FONT_R(_ size: CGFloat) -> UIFont
{
    return UIFont.init(name: PFSCR, size: size)!
}

public func FONT_M(_ size: CGFloat) -> UIFont
{
    return UIFont.init(name: PFSCM, size: size)!
}

public func FONT_S(_ size: CGFloat) -> UIFont
{
    return UIFont.init(name: PFSCS, size: size)!
}

public func FONT_L(_ size: CGFloat) -> UIFont
{
    return UIFont.init(name: PFSCL, size: size)!
}

public func FONT_U(_ size: CGFloat) -> UIFont
{
    return UIFont.init(name: PFSCU, size: size)!
}

public func FONT_T(_ size: CGFloat) -> UIFont
{
    return UIFont.init(name: PFSCT, size: size)!
}


