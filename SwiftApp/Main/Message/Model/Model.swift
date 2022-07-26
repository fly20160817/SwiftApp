//
//  Model.swift
//  WaterFlow
//
//  Created by fly on 2022/6/28.
//

import UIKit
import KakaJSON

//必须遵守 Convertible协议，才可以使用KakaJSON
struct Model: Convertible {

    var artWorkName: String?
    var appreciateArtUrl: String?
    
    
    //下载图片后，才会赋值宽高
    var imageH: CGFloat?
    var imageW: CGFloat?
}
