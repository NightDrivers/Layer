//
//  ScrawlTestView.swift
//  Layer
//
//  Created by ldc on 2017/7/7.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class ScrawlTestView: UIView {
    
    var lines = [ScrawlTestModel]()
    
    var lineWidth: CGFloat = 10
    var lastTouchTimestamp : TimeInterval!
    
    lazy var distance: Double = {
        let temp = Double(sqrt(pow(self.frame.size.width, 2) + pow(self.frame.size.height, 2)))*20
        return temp
    }()
    
    override func draw(_ rect: CGRect) {
        
        for item in lines {
            
            let bezierPath = UIBezierPath()
            bezierPath.move(to: item.startPoint)
            bezierPath.addLine(to: item.endPoint)
            bezierPath.lineCapStyle = .round
            bezierPath.lineJoinStyle = .round
            bezierPath.lineWidth = item.lineWidth
            UIColor.black.setStroke()
            bezierPath.stroke()
        }
    }
    
}

extension ScrawlTestView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        lastTouchTimestamp = touch.timestamp
//        lines.append(ScrawlTestModel.init(touch.previousLocation(in: self), touch.location(in: self), lineWidth))
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let timeSpace = touch.timestamp - lastTouchTimestamp
        let distanceX = fabs(touch.location(in: self).x - touch.previousLocation(in: self).x)
        let distanceY = fabs(touch.location(in: self).y - touch.previousLocation(in: self).y)
        let distance = Double(sqrt(pow(distanceX, 2) + pow(distanceY, 2)))
//        print("\(distance/timeSpace)")
        print("开始点：\(touch.preciseLocation(in: self)) 结束点：\(touch.location(in: self))")
        lastTouchTimestamp = touch.timestamp
        let tempLineWidth = 10.0*(1 - distance/timeSpace/self.distance > 0 ? 1 - distance/timeSpace/self.distance : 0)
        let tempModel = ScrawlTestModel.init(touch.previousLocation(in: self), touch.location(in: self), CGFloat(tempLineWidth))
//        lines.append(ScrawlTestModel.init(touch.previousLocation(in: self), touch.location(in: self), CGFloat(tempLineWidth)))
        addcompenentToLines(model: tempModel, CGFloat(distance), distanceX, distanceY)
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let timeSpace = touch.timestamp - lastTouchTimestamp
        let distanceX = fabs(touch.location(in: self).x - touch.previousLocation(in: self).x)
        let distanceY = fabs(touch.location(in: self).y - touch.previousLocation(in: self).y)
        let distance = Double(sqrt(pow(distanceX, 2) + pow(distanceY, 2)))
//        print("\(distance/timeSpace)")
//        print("\(timeSpace)")
        lastTouchTimestamp = touch.timestamp
//        print("touch 结束")
        if lines.last!.lineWidth == 0  {
            return
        }
        let tempLineWidth = 10.0*(1 - distance/timeSpace/self.distance > 0 ? 1 - distance/timeSpace/self.distance : 0)
        lines.append(ScrawlTestModel.init(touch.previousLocation(in: self), touch.location(in: self), CGFloat(tempLineWidth)))
        self.setNeedsDisplay()
    }
    
    func addcompenentToLines(model: ScrawlTestModel,_ distance: CGFloat,_ distanceX: CGFloat,_ distanceY: CGFloat) -> Void {
        
        let pieces: CGFloat = 1/distance
        if lines.count == 0 {
            
            for i in 0...Int(distance) - 1 {
                let startPoint = CGPoint.init(x: model.startPoint.x + distanceX*pieces*CGFloat(i), y: model.startPoint.y + distanceY*pieces*CGFloat(i))
                let endPoint = CGPoint.init(x: model.startPoint.x + distanceX*pieces*CGFloat(i + 1), y: model.startPoint.y + distanceY*pieces*CGFloat(i + 1))
                lines.append(ScrawlTestModel.init(startPoint, endPoint, model.lineWidth*CGFloat(i+1)*CGFloat(pieces)))
                print("\(startPoint)  \(endPoint)")
            }
            self.setNeedsDisplay()
        }else {
            
            if distance - 1 < 0 {
                return
            }
            let lastLineWidth = lines.last!.lineWidth
            for i in 0...Int(distance) - 1 {
                let startPoint = CGPoint.init(x: model.startPoint.x + distanceX*pieces*CGFloat(i), y: model.startPoint.y + distanceY*pieces*CGFloat(i))
                let endPoint = CGPoint.init(x: model.startPoint.x + distanceX*pieces*CGFloat(i + 1), y: model.startPoint.y + distanceY*pieces*CGFloat(i + 1))
                print("\(startPoint)  \(endPoint)")
                lines.append(ScrawlTestModel.init(startPoint, endPoint, lastLineWidth + (model.lineWidth - lastLineWidth)*CGFloat(i+1)*CGFloat(pieces)))
            }
            self.setNeedsDisplay()
        }
    }
}

//extension CGPoint {
//    
//    func distance(from: CGPoint,to: CGPoint) -> Double {
//        
//        let distanceX = fabs(from.x - from.x)
//        let distanceY = fabs(from.y - to.y)
//        let distance = Double(sqrt(pow(distanceX, 2) + pow(distanceY, 2)))
//        return distance
//    }
//}

class ScrawlTestModel: NSObject {
    
    var lineWidth : CGFloat = 10;
    var startPoint = CGPoint.zero
    var endPoint = CGPoint.zero
    
    init(_ startPoint: CGPoint,_ endPoint: CGPoint,_ lineWidth: CGFloat) {
        
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.lineWidth  = lineWidth
        super.init()
    }
}
