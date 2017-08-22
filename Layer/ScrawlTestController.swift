//
//  ScrawlTestController.swift
//  Layer
//
//  Created by ldc on 2017/7/6.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class ScrawlTestController: UIViewController {

    @IBAction func undo(_ sender: UIButton) {
        scrawlView.undo()
    }
    @IBAction func redo(_ sender: UIButton) {
        scrawlView.redo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrawlView.frame = CGRect.init(x: 0, y: 108, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 108)
//        scrawlTestView.frame = CGRect.init(x: 0, y: 108, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 108)
    }
    
    lazy var scrawlView: ScrawlView = {
        let temp = ScrawlView()
//        temp.backgroundColor = UIColor.lightGray
        self.view.addSubview(temp)
        return temp
    }()
    
    lazy var scrawlTestView: ScrawlTestView = {
        let temp = ScrawlTestView()
        temp.backgroundColor = UIColor.lightGray
        self.view.addSubview(temp)
        return temp
    }()
}
