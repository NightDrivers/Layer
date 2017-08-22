//
//  ScorllSegmentedView.swift
//  CardPrinter
//
//  Created by ldc on 2017/7/27.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

protocol ScorllSegmentedViewDelegate: NSObjectProtocol {
    
    func scorllSegmentedView(_ scorllSegmentedView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> Void
}

class ScorllSegmentedView: UICollectionView {
    
    var iden = "iden"
    var titles = [String]()
    var font = UIFont.systemFont(ofSize: 13)
    var addSize = CGSize.init(width: 14, height: 7)
    var textModels = [ScrollTextModel]()
    var minSpace: CGFloat = 14
    weak var scorllSegmentedViewDelegate: ScorllSegmentedViewDelegate?
    
    init() {
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        super.init(frame: CGRect.zero, collectionViewLayout: flowlayout)
        backgroundColor = UIColor.clear
        delegate = self
        dataSource = self
    }
    
    func reset(with frame: CGRect,_ titles: [String]) -> Void {
        
        self.frame = frame
        contentSize = bounds.size
        self.titles = titles
        var contentLength: CGFloat = 0
        textModels.removeAll()
        for item in titles {
            let model = ScrollTextModel.init(with: item, font, append: addSize)
            contentLength += model.size.width
            textModels.append(model)
        }
        let minContentSpaceSum: CGFloat = CGFloat((titles.count - 1)*14)
        let maxContentSpaceSum: CGFloat = CGFloat((titles.count - 1)*26)
        // 32 左右两侧边缘保留宽度
        if contentLength + maxContentSpaceSum + 32 < frame.size.width {
            
            contentInset = UIEdgeInsets.init(top: (frame.size.height - textModels[0].size.height)/2, left: (frame.size.width - contentLength - maxContentSpaceSum)/2 + 16, bottom: (frame.size.height - textModels[0].size.height)/2, right: (frame.size.width - contentLength - maxContentSpaceSum)/2 + 16)
            minSpace = 26
        }else if contentLength + minContentSpaceSum < frame.size.width {
            contentInset = UIEdgeInsets.init(top: (frame.size.height - textModels[0].size.height)/2, left: 16, bottom: (frame.size.height - textModels[0].size.height)/2, right: 16)
            minSpace = (frame.size.width - contentLength - 32)/CGFloat(titles.count - 1)
        }else {
            contentInset = UIEdgeInsets.init(top: (frame.size.height - textModels[0].size.height)/2, left: 16, bottom: (frame.size.height - textModels[0].size.height)/2, right: 16)
            minSpace = 14
        }
        reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ScorllSegmentedView : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return textModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iden, for: indexPath) as! TextCollectionCell
        cell.backgroundColor = UIColor.magenta
        cell.text = textModels[indexPath.row].text
        cell.label?.font = font
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return minSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return textModels[indexPath.row].size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        scorllSegmentedViewDelegate?.scorllSegmentedView(self, didSelectItemAt: indexPath)
    }
}

class ScrollTextModel: NSObject {
    
    var text = ""
    var size = CGSize.zero
    
    init(with text: String,_ font: UIFont,append size: CGSize) {
        
        super.init()
        let rect = (text as NSString).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: font.pointSize), options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [NSFontAttributeName : font], context: nil)
        self.text = text
        self.size = CGSize.init(width: ceil(rect.size.width) + 1 + size.width, height: font.pointSize + size.height)
    }
}

class TextCollectionCell: UICollectionViewCell {
    
    var label: UILabel?
    var text: String? {
        
        didSet {
            
            didSetText()
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        lazyLabel().frame = bounds
    }
    
    open func didSetText() -> Void {
        
        lazyLabel().text = text
    }
    
    fileprivate func lazyLabel() -> UILabel {
        
        if let _ = label {
            return label!
        }else {
            let temp = UILabel()
            temp.textColor = UIColor.white
            temp.textAlignment = .center
            temp.font = UIFont.systemFont(ofSize: 20)
            addSubview(temp)
            label = temp
            return temp
        }
    }
}
