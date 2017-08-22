//
//  ScrollSegmentedViewTestController.swift
//  Layer
//
//  Created by ldc on 2017/7/27.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class ScrollSegmentedViewTestController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        let temp = ScorllSegmentedView()
        temp.reset(with: CGRect.init(x: 0, y: 300, width: UIScreen.main.bounds.size.width, height: 50), ["阿道夫的","啊","多的","阿道夫的","啊","多的"])
        temp.register(TextCollectionCell.self, forCellWithReuseIdentifier: temp.iden)
        view.addSubview(temp)
    }

}
