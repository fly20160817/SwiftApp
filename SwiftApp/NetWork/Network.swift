//
//  Network.swift
//  SwiftApp
//
//  Created by fly on 2022/7/21.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class Network
{
    class func request(path: String, method: MethodType = .get, params: [String : Any]? = nil, success: @escaping (_ jsonData: Data?)->(), failure: @escaping (_ error: Error)->() )
    {
        var m: HTTPMethod
        
        switch method
        {
        case .get:
            m = .get
            
        case .post:
            m = .post
        }
        
        
        AF.request(path, method: m, parameters: params, headers: nil, interceptor: nil, requestModifier: nil).response { responseObject in
                        
            switch responseObject.result
            {
            case .success(let value):
                success(value)
                
            case .failure(let error):
                failure(error)
            }
            
        }

    }
    
    
    
    /// 判断是否有网
    /// - Parameter status: 是否有网的回调
    class func getNetworkStatus(_ networkStatus: @escaping (_ isNetwork: Bool) -> () )
    {
        //创建监听管理者
        let manager = NetworkReachabilityManager.default
        
        //监听网络状态的改变
        manager?.startListening(onUpdatePerforming: { status in
            
            switch status
            {
            case .unknown:
                print("网络状态未知")
                networkStatus(false)
                
            case .notReachable:
                print("暂时没有网络连接")
                networkStatus(false)
                
            case .reachable(.cellular):
                print("蜂窝数据")
                networkStatus(true)
                
            case .reachable(.ethernetOrWiFi):
                print("以太网或者WiFi")
                networkStatus(true)
                
            }
            
            //停止检测网络状态
            manager?.stopListening()
            
        })
    }
}
