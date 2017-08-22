//
//  CustomSliderController.swift
//  Layer
//
//  Created by ldc on 2017/8/4.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class CustomSliderController: UIViewController {
    
    var slider: PTSliderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        slider = PTSliderView.init(frame: CGRect.init(x: 100, y: 100, width: 300, height: 50), .center)
        slider.delegate = self
        slider.backgroundColor = UIColor.black
        view.addSubview(slider)
    }
}

extension CustomSliderController: PTSliderViewDelegate {
    
    func slider(_ sliderView: PTSliderView, slided value: CGFloat) {
        
        print("滑动结束")
    }
    
    func slider(_ sliderView: PTSliderView, sliding value: CGFloat) {
        
        print("正在滑动")
    }
}
