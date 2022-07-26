//
//  ExceptionView.swift
//  SwiftApp
//
//  Created by fly on 2022/7/19.
//

import UIKit

@objcMembers class ExceptionView: UIView, FLYDataStatusProtocal {
    
    /* 协议里的属性，拷贝出来实现。 */
    
    
    //UITableView+FLYRefresh内部获取到数据后给status赋值，其他地方不要赋值。
    var status: FLYExceptionStatus {
        didSet {
            
            switch status
            {
            case .none:
                isHidden = true
                
            case .noData:
                isHidden = false
                
                let dic: Dictionary = dataList[0] as! Dictionary<String, String>
                imageView.image = image ?? imageName(dic[imageKey]!)
                titleLabel.text = title ?? dic[titleKey]
                subtitleLabel.text = subtitle ?? dic[subtitleKey]
                
            case .serverError:
                isHidden = false
                
                let dic: Dictionary = dataList[1] as! Dictionary<String, String>
                imageView.image = image ?? imageName(dic[imageKey]!)
                titleLabel.text = title ?? dic[titleKey]
                subtitleLabel.text = subtitle ?? dic[subtitleKey]
                
            case .networkError:
                isHidden = false
                
                let dic: Dictionary = dataList[2] as! Dictionary<String, String>
                imageView.image = image ?? imageName(dic[imageKey]!)
                titleLabel.text = title ?? dic[titleKey]
                subtitleLabel.text = subtitle ?? dic[subtitleKey]
                
            default:
                break
                
            }
            
        }
    }
    
    //可以不赋值，内部有默认值。但要是哪个页面无数据的时候，需要显示不一样的文字或图片，这时才赋值。
    var image: UIImage?
    var title: String?
    var subtitle: String?
    
    
    
    private lazy var imageView: UIImageView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FONT_R(16)
        label.textColor = colorHex("#04A1FD")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = FONT_R(14)
        label.textColor = colorHex("#04A1FD")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dataList: NSArray = {
        
        let dic1 = [ imageKey : "img_empty", titleKey : "暂无内容", subtitleKey : "去逛逛之后再来吧~~" ]
        let dic2 = [ imageKey : "img_error", titleKey : "系统错误", subtitleKey : "请稍后重试~~" ]
        let dic3 = [ imageKey : "img_collapse", titleKey : "网络崩溃", subtitleKey : "请检查网络连接~~" ]
        let array: NSArray = [dic1, dic2, dic3]
        
        return array
        
    }()
    
    private let imageKey = "imageName"
    private let titleKey = "title"
    private let subtitleKey = "subtitle"
    
    

    override init(frame: CGRect) {
        
        status = .none
        
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset((height - 300) / 2.0)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 162, height: 210))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(42)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
            make.height.equalTo(22)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16);
            make.height.equalTo(20)
        }
    }
}



// MARK: - UI

private extension ExceptionView
{
    func initUI()
    {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
}
