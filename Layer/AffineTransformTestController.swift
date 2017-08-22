//
//  AffineTransformTestController.swift
//  Layer
//
//  Created by ldc on 2017/7/20.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class AffineTransformTestController: UIViewController {

    @IBOutlet weak var rotateSlider: UISlider!
    @IBOutlet weak var testView1: UIView!
    var testView1Center: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rotateSlider.minimumValue = 0
        rotateSlider.maximumValue = Float(M_PI*2)
        testView1Center = testView1.center
    }

    @IBAction func rotateChange(_ sender: UISlider) {
        
        testView1.center = testView1Center.transform(CGAffineTransform.init(rotationAngle: CGFloat(sender.value)), CGPoint.init(x: 200, y: 200))
    }
}
