//
//  WaterFlowLayout.swift
//  瀑布流
//
//  Created by fly on 2022/6/27.
//

import UIKit

public protocol WaterFlowLayoutDelegate
{
    /**
        设置每个item的高度
     */
    func waterFlowLayout(_ layout: WaterFlowLayout, heightForItemAt indexPath: IndexPath, itemWidth width: CGFloat) -> CGFloat
}


public class WaterFlowLayout: UICollectionViewLayout
{

    var delegate: WaterFlowLayoutDelegate?
    
    //列数 (默认2)
    var columnCount: Int = 2
    //列间距 (默认10)
    var columnSpacing: CGFloat = 10
    //行间距 (默认10)
    var rowSpacing: CGFloat = 10
    //边缘间距 (默认10)
    var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    
    /** 存放所有cell的布局属性 */
    private var attrsArray: Array<UICollectionViewLayoutAttributes> = []
    /** 存放所有列的当前高度 */
    private var columnHeights: Array<CGFloat> = []
    /** 内容的高度 */
    private var contentHeight: CGFloat = 0
    
    
    
    //初始化 (布局之前，可以在这个方法中做一些初始化设置)
    override public func prepare()
    {
        super.prepare()
        
        
        /*刷新列表的时候需要重新计算*/
        
        contentHeight = 0;
        
        
        
        // 清除以前计算的所有高度
        columnHeights.removeAll();
        
        for _ in 0 ..< columnCount
        {
            columnHeights.append(edgeInsets.top)
        }
        
        
        
        // 清除之前所有的布局属性
        attrsArray.removeAll()
        
        //获取第0组item的数量
        let itemCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        //开始创建每一个cell对应的布局属性
        for i in 0 ..< itemCount
        {
            let indexPath = IndexPath(item: i, section: 0)
            
            // 获取indexPath位置cell对应的布局属性
            let attributes = layoutAttributesForItem(at: indexPath)!
            
            attrsArray.append(attributes)
        }
    }
    
    
    
    //决定cell的排布
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        return attrsArray
    }
    
    //返回indexPath位置cell对应的布局属性
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        //创建布局属性对象
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        //记录高度最短的那一列
        var shortColumn = 0
        //记录最短的高度是多少
        var minColumnHeight = columnHeights[shortColumn]

        for i in 1 ..< columnCount
        {
            let columnHeight = columnHeights[i]

            if minColumnHeight > columnHeight
            {
                minColumnHeight = columnHeight;
                shortColumn = i;
            }
        }
       
       
        let width = ( collectionView!.frame.width - edgeInsets.left - edgeInsets.right - columnSpacing * CGFloat(columnCount - 1) ) / CGFloat(columnCount);
        let height: CGFloat = delegate?.waterFlowLayout(self, heightForItemAt: indexPath, itemWidth: width) ?? 0
        let originX = edgeInsets.left + CGFloat(shortColumn) * (width + columnSpacing);
        var originY = minColumnHeight;
        if ( originY != edgeInsets.top )
        {
            originY += rowSpacing;
        }

        attributes.frame = CGRect(x: originX, y: originY, width: width, height: height)
        columnHeights[shortColumn] = attributes.frame.maxY
        
        // 记录内容的高度
        let columnHeight = columnHeights[shortColumn]
        if ( contentHeight < columnHeight )
        {
            contentHeight = columnHeight;
        }
        
        return attributes
    }
   
    
    
    //collection的内容尺寸 (滚动大小)
    public override var collectionViewContentSize: CGSize
    {
        return CGSize(width: 0, height: contentHeight + edgeInsets.bottom)
    }
    
}


