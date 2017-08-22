//
//  TextController.swift
//  Layer
//
//  Created by ldc on 2017/7/31.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class TextController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var attributeString : NSMutableAttributedString!
    var paragrap : NSMutableParagraphStyle!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        attributeString = NSMutableAttributedString.init(string: "南派三叔原名徐磊，浙江嘉善人，曾就读于嘉善二中，毕业于浙江树人大学[16]  。曾做过广告美工、软件编程、国际贸易等诸多行业。[17]  因为小时年弱多病，所以尝试用写作的方式构建自己想象中的世界，常常以身边人如家人与同学作为原型进\n行创作。[18]  在一篇《盗墓笔记》的番外里，南派三叔写道，5岁的自己，窝在外婆怀里时，听到了人生里第一个和尸体有关的故事，讲的是村中大户院子底下挖出的血尸，从此对地底下的神秘世界产生了浓厚的想象。[18]  2006年他开始在网上进行文学创作，写下第一篇《七星鲁王宫》，受到网友热捧，有了自己的固定书粉，粉丝们追着他催更，于是开始白天上班，晚上更文，一有空暇，随处打开电脑就可以文思泉涌。[18]  他的连载地从贴吧转移到起点中文网，半年后，正式整理成书，《盗墓笔记：七星鲁王宫》就是《盗墓笔记》系列的第一本成书。[18")
        attributeString.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 10)], range: NSRange.init(location: 0, length: attributeString.length))
        paragrap = NSMutableParagraphStyle()
        paragrap.alignment = .left
        paragrap.firstLineHeadIndent = 30
        paragrap.headIndent = 10
        paragrap.tailIndent = -10
        paragrap.lineSpacing = 0
//        paragrap.paragraphSpacing = 10
        paragrap.paragraphSpacingBefore = 10
        attributeString.addAttributes([NSParagraphStyleAttributeName:paragrap], range: NSRange.init(location: 0, length: attributeString.length))
        attributeString.addAttributes([NSUnderlineStyleAttributeName:1], range: NSRange.init(location: 0, length: attributeString.length))
//        attributeString.addAttributes([NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle], range: NSRange.init(location: 0, length: attributeString.length))
        label.attributedText = attributeString
//        label.text = "南派三叔原名徐磊，浙江嘉善人，曾就读于嘉善二中，毕业于浙江树人大学[16]  。曾做过广告美工、软件编程、国际贸易等诸多行业。[17]  因为小时年弱多病，所以尝试用写作的方式构建自己想象中的世界，常常以身边人如家人与同学作为原型进\n行创作。[18]  在一篇《盗墓笔记》的番外里，南派三叔写道，5岁的自己，窝在外婆怀里时，听到了人生里第一个和尸体有关的故事，讲的是村中大户院子底下挖出的血尸，从此对地底下的神秘世界产生了浓厚的想象。[18]  2006年他开始在网上进行文学创作，写下第一篇《七星鲁王宫》，受到网友热捧，有了自己的固定书粉，粉丝们追着他催更，于是开始白天上班，晚上更文，一有空暇，随处打开电脑就可以文思泉涌。[18]  他的连载地从贴吧转移到起点中文网，半年后，正式整理成书，《盗墓笔记：七星鲁王宫》就是《盗墓笔记》系列的第一本成书。[18"
        label.adjustsFontSizeToFitWidth = true
        print("\(label.frame)")
        for i in 0...200 {
            print("\(label.sizeThatFits(CGSize.init(width: CGFloat(i), height: CGFloat(i))))" + "    \(i)")
        }
    }
}
