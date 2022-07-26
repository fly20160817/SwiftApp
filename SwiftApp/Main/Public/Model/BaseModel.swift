//
//  BaseModel.swift
//  SwiftApp
//
//  Created by fly on 2022/7/15.
//

import UIKit
import KakaJSON

//必须遵守 Convertible协议，才可以使用KakaJSON
class BaseModel: NSObject, Convertible {
    
    
    /**
     协议“Convertible”需要init构造函数，用于完全初始化实例。如果是结构体，则就不需要加init()。
     如果分不清加不加init()，可以先不加，如果需要加的我们没加，会有报错提醒。
     添加“override”，因为BaseModel继承的是NSObject，NSObject也有“init”。
     */
    required override init()
    {
        
    }
    
    //kj_modelKey方法会把每个属性名字传过来，可以在这里修改和服务器对应的名字
    func kj_modelKey(from property: Property) -> ModelPropertyKey
    {
        switch property.name
        {
        case "idField":
            return "id"
            
        case "descriptionField":
            return "description"
            
        default: return property.name
        }
    }
    
/*
    //kj_modelValue方法会把每个属性名字和值传过来，可以在这里修改值
    func kj_modelValue(from jsonValue: Any?, _ property: Property) -> Any?
    {
        //例如，发现是 idField 属性时，并且它的值时001，则就把它的值改成10086
        if property.name == "idField" && jsonValue as! String  == "001"
        {
            return 10086
        }

        return jsonValue
    }
 */
    
    
    /**
     //字典数组 转 模型数组
     let models = modelArray(from: array, type: BaseModel.self)
     或
     let models = array.kj.modelArray(BaseModel.self)
     
     //字典 转 模型
     let model: BaseModel = model(from: dic, type: BaseModel.self) as! BaseModel
     或
     let model = dic.kj.model(BaseModel.self)
     
     
     
     //模型数组 转 json字符串
     let jsonString = models.kj.JSONString()
     或
     let jsonString = JSONString(from: models)
     
     //模型 转 json字符串
     let jsonString1 = model.kj.JSONString()
     或
     let jsonString2 = JSONString(from: model)
     
     */
}
