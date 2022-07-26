//
//  Cell.swift
//  瀑布流
//
//  Created by fly on 2022/6/28.
//

import UIKit
import SDWebImage
import SnapKit

class Cell: UICollectionViewCell {
    

    
    public var model: Model {
        
        didSet{
            
            //从缓存中获取获取已经下载好的图片 (虽然下载的顺序不能保证，但全部下载完后，通过url去缓存里取图片，一定是想要的那张，和什么顺序无关)
            photoView.image = SDImageCache.shared.imageFromDiskCache(forKey: model.appreciateArtUrl)
            
            nameLabel.text = model.artWorkName
            
            makeConstraints()
        }
    }
    
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        
        self.model = Model()
        
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - UI
    
    private func initUI()
    {
        contentView.backgroundColor = UIColor.cyan
        
        contentView.addSubview(photoView)
        contentView.addSubview(nameLabel)
        
        makeConstraints()
    }
    
    private func makeConstraints()
    {
        photoView.snp.remakeConstraints { make in
            make.edges.equalTo(0)
        }
        
        nameLabel.snp.remakeConstraints { make in
            make.edges.equalTo(0)
        }
    }
}
