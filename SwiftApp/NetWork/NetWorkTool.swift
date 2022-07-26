//
//  NetWorkTool.swift
//  SwiftApp
//
//  Created by fly on 2022/7/25.
//


/**
 
 FLYNetwork是最纯净的类，一般不动它。
 我们新增FLYNetworkTool这个类，处理所有的业务逻辑，比如Loading、状态码判断、加密解密等。
 
 */


import Foundation

enum NetworkLoadingType
{
    case none                  //无Loading
    case interaction           //有Loading，背景可点击
    case notInteractionClear   //有Loading，背景不可点击，背景透明
    case notInteractionBlack   //有Loading，背景不可点击，背景黑色膜
}

class NetWorkTool
{
    /// 网络请求
    /// - Parameters:
    ///   - path: url地址
    ///   - method: 请求类型
    ///   - params: 参数
    ///   - loading: loading类型
    ///   - loadingTitle: loading文字
    ///   - isHandle: 返回结果是否需要内部处理（YES 只返回200的情况，其他状态码或请求失败都show出错误信息；NO  任何状态都直接返回出来给外界处理，不show任何信息）
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调
    class func request(path: String, method: MethodType = .get, params: [String : Any]? = nil, loadingType: NetworkLoadingType = .interaction, loadingTitle: String? = "请稍后", isHandle: Bool = true, success: @escaping (_ json: JSON)->(), failure: @escaping (_ error: Any)->() )
    {
        setupLoading(type: loadingType, title: loadingTitle, showProgress: false)
        
        Network.request(path: path, method: method, params: params) { jsonData in
                        
            successHandle(isHandle, loadingType: loadingType, jsonData: jsonData, success: success, failure: failure)
            
        } failure: { error in
            
            failureHandle(isHandle, loadingType: loadingType, error: error, failure: failure)
        }
        


    }
    
}



// MARK: - private methods

private extension NetWorkTool
{
    /// 设置Loading
    /// - Parameters:
    ///   - type: loading类型
    ///   - title: 文字
    ///   - showProgress: 是否显示进度 (上传和下载传YES)
    class func setupLoading(type: NetworkLoadingType, title: String?, showProgress: Bool)
    {
        if( type != .none )
        {
            showProgress == true ? SVProgressHUD.showProgress(0, status: title) : SVProgressHUD.show(withStatus: title)
        }
        
        
        if ( type == .interaction )
        {
            SVProgressHUD.setDefaultMaskType(.none)
        }
        else if ( type == .notInteractionClear )
        {
            SVProgressHUD.setDefaultMaskType(.clear)
        }
        else if ( type == .notInteractionBlack )
        {
            SVProgressHUD.setDefaultMaskType(.black)
        }
    }
    
    
    
    /// 请求成功的处理
    /// - Parameters:
    ///   - isHandle: 返回结果是否需要内部处理
    ///   - loadingType: loading类型
    ///   - json: 返回的数据
    ///   - success: 成功回调
    ///   - failure: 失败回调
    class func successHandle(_ isHandle: Bool, loadingType: NetworkLoadingType, jsonData: Data?, success: @escaping (_ json: JSON)->(), failure: @escaping (_ error: Any)->() )
    {
        if ( loadingType != .none )
        {
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultMaskType(.none)
        }
        
        
        
        //使用SwiftyJSON框架读取json数据
        let json = JSON(jsonData!)
        let jsonDic = json.dictionaryObject
        
        guard let code = jsonDic?["code"] as? Int else {
            failure(json)
            return
        }
        
        if ( code != 200 && isHandle )
        {
            guard let message = jsonDic?["message"] as? String else {
                failure(json)
                return
            }
            
            SVProgressHUD.showError(withStatus: message)
            failure(json)
        }
        else
        {
            success(json)
        }
        
    }
    
    
    
    class func failureHandle(_ isHandle: Bool, loadingType: NetworkLoadingType, error: Any, failure: @escaping (_ error: Any)->() )
    {
        if ( loadingType != .none )
        {
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultMaskType(.none)
        }
        
        
        if ( isHandle )
        {
            Network.getNetworkStatus { isNetwork in
                SVProgressHUD.showInfo(withStatus: isNetwork ? "服务器异常，请稍后重试。" : "您的网络好像出现了问题")
                SVProgressHUD.setDefaultMaskType(.none)
            }
        }
        
        failure(error)
    }
    
}

