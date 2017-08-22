//
//  TouchTestController.swift
//  Layer
//
//  Created by ldc on 2017/7/11.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class TouchTestController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let touchTestView = TouchTestView.init(frame: CGRect.init(x: 0, y: 64, width: 300, height: 300))
        touchTestView.backgroundColor = UIColor.cyan
        view.addSubview(touchTestView)
        
        let touchTestView1 = TouchTestView1.init(frame: CGRect.init(x: 0, y: 364, width: 300, height: 300))
        touchTestView1.backgroundColor = UIColor.magenta
        view.addSubview(touchTestView1)
        
        self.perform(#selector(TouchTestController.test1))
        self.perform(#selector(TouchTestController.test1), with: "a")
        let model1 = SelectorTestModel.init(with: self, #selector(TouchTestController.test1))
        model1.run()
    }
    
    func test1() -> Void {
        print("test1 success")
    }
    
    func test2(str1: String) -> Void {
        print("test2:\(str1)")
    }

}

class SelectorTestModel: NSObject {
    
    var target: AnyObject!
    var selector: Selector!
    
    init(with target: AnyObject,_ selector: Selector) {
        
        super.init()
        self.target = target
        self.selector = selector
    }
    
    func run() -> Void {
        
        let _ = self.target.perform(selector)
    }
}
