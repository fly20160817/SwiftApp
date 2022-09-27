//
//  MessageViewController.swift
//  SwiftApp
//
//  Created by fly on 2022/7/19.
//


/*
 瀑布流 - 接口没返回图片的宽高
 
 解决方案：
 
 1.请求接口，拿到数据
 
 2.更具数据里的图片url，遍历下载所有的图片
    2.1 使用GCD的调度组 配合 SDWebImage 下载图片
        (虽然下载的顺序不能保证，但全部下载完后，通过url去缓存里取图片，一定是想要的那张，和什么顺序无关)
    2.2 把图片的宽高赋值给model
 
 3.刷新数据
   3.1 cell里赋值图片的时候，不需要再下了，通过url去SDImageCache缓存中获取获取已经下载好的图片
 
 */



import UIKit
import SDWebImage

class MessageViewController: BaseViewController {

    private lazy var collectionView: UICollectionView = {
      
        let layout = FLYWaterFlowLayout()
        layout.delegate = self
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = view.backgroundColor
        collectionView.dataSource = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: collectionView.cellReuseIdentifier)
        collectionView.addRefreshingTarget(self, action: #selector(getListNetwork))
        
        return collectionView
    }()
    
    private lazy var dataList = [Model]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        loadData()
        initUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
}



// MARK: - DATA

private extension MessageViewController
{
    func loadData()
    {
        collectionView.mj_header?.beginRefreshing()
    }
}



// MARK: - NETWORK

private extension MessageViewController
{
    @objc private func getListNetwork()
    {

        
        var params = [ "pageNum" : collectionView.pageNum, "pageSize" : collectionView.pageSize] as [String : Any]
        params = [ "SearchContentRequest" : NSString.object(toJson: params) ]
        
        let urlString = "https://www.jianhua-art.com/api/mobile/discoverArt/original"
                
        
        NetWorkTool.request(path: urlString, method: .get, params: params, loadingType: .none, loadingTitle: nil, isHandle: true) { [weak self] json in

            //使用SwiftyJSON框架读取json数据，并转成数组
            let jsonArray = json["data"]["list"].arrayObject

            //利用KakaJSON，将 字典数组 转 model数组
            let modelArray = modelArray(from: jsonArray!, Model.self)

            // 缓存配图
            self?.cachesImages(models: modelArray, total: UInt(json["data"]["total"].rawValue as! UInt))

        } failure: { error in

            print("失败：\(error)")
            
            self.collectionView.loadDataFailed(error)
        }

    }
    
    
    
    // 缓存配图
    private func cachesImages(models: [Model], total: UInt)
    {
        // 1.创建一个组
        let group = DispatchGroup()
        
        var newModels = [Model]()
        
        for var model in models
        {
            //2.声明dispatch_group_enter(group)下面的任务由group组管理，group组的任务数+1
            group.enter();
            
            //3.利用SDWebImage下载图片
            SDWebImageManager.shared.loadImage(with: URL(string: model.appreciateArtUrl ?? ""), options: SDWebImageOptions(rawValue: 0), context: nil, progress: nil) { image, _, error, _, _, _ in
                
                if  let err = error
                {
                    print("下载失败：\(err)")
                }
                else
                {
                    print("下载完成:\(String(describing: model.appreciateArtUrl))")
                }
                
                
                model.imageH = image?.size.height
                model.imageW = image?.size.width
                
                newModels.append(model)
                
                //4.相应的任务执行完成，group组的任务数-1
                group.leave();
            }
        }
        
        //5.等待组中的任务都执行完毕，才会执行 (执行时代码会不会停在这行，会继续往下执行)
        //原理：判读group里的任务数是否为0，为0就执行dispatch_group_notify里的代码
        group.notify(queue: DispatchQueue.main) {
            
            print("全部下载完成")
            
            self.collectionView.loadDataSuccess(newModels, total: total)
        }
    }
}



// MARK: - UI

private extension MessageViewController
{
    func initUI()
    {
        navigationItem.title = "瀑布流"
        
        view.addSubview(collectionView)
    }
}



// MARK: - 协议

extension MessageViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return collectionView.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView.cellReuseIdentifier, for: indexPath) as! Cell

        cell.model = collectionView.dataList[indexPath.item] as! Model
       
        return cell
    }
}

extension MessageViewController: FLYWaterFlowLayoutDelegate
{
    func waterFlowLayout(_ layout: FLYWaterFlowLayout, heightForItemAt indexPath: IndexPath, itemWidth width: CGFloat) -> CGFloat
    {
        let model: Model = collectionView.dataList[indexPath.item] as! Model
        
        //如果为nil，返回100
        guard let imageWidth = model.imageW, let imageHeight = model.imageH else {
            return 100
        }
        
        //如果为0，返回100
        if ( imageWidth == 0 || imageHeight == 0 )
        {
            return 100;
        }
        
        return width / ( imageWidth / imageHeight)
    }
}


