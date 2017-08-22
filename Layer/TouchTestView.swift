//
//  TouchTestView.swift
//  Layer
//
//  Created by ldc on 2017/7/11.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class TouchTestView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        return hit
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        print("\(point)")
        return self.bounds.insetBy(dx: -100, dy: -100).contains(point)
//        let isInside = super.point(inside: point, with: event)
//        return isInside
//        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("\(event)")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        print("\(event)")
    }
}
