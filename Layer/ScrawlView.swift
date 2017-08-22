//
//  ScrawlView.swift
//  Layer
//
//  Created by ldc on 2017/7/6.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

fileprivate extension UIColor {
    func image() -> UIImage {
        
        let rect = CGRect.init(x: 0, y: 0, width: 2, height: 2)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

class ScrawlView: UIView {
    
    var minX: CGFloat = 0
    var minY: CGFloat = 0
    var maxX: CGFloat = 0
    var maxY: CGFloat = 0
    var wordRect: CGRect = .zero
    
    var points: [CGPoint] = [CGPoint]()
    
    var brushWidth: CGFloat = 20
    var brushColor: UIColor = UIColor.black

    var compenents = [ScrawlCompenentModel]()
    
    lazy var maskImageView: UIImageView = {
        let temp = UIImageView.init(frame: self.bounds)
        temp.backgroundColor = UIColor.clear
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {

        for item in compenents {
            item.image .draw(at: item.frame.origin)
        }
    }
    
    /**
     画图
     */
    func changeImage(){
        UIGraphicsBeginImageContextWithOptions(maskImageView.frame.size, false, UIScreen.main.scale)
        maskImageView.draw(maskImageView.bounds)
        
        // 贝赛尔曲线的起始点和末尾点
        let tempPoint1 = CGPoint.init(x: (points[0].x+points[1].x)/2, y: (points[0].y+points[1].y)/2)
        let tempPoint2 = CGPoint.init(x: (points[1].x+points[2].x)/2, y: (points[1].y+points[2].y)/2)
        
        // 贝赛尔曲线的估算长度
        let x1 = abs(tempPoint1.x-tempPoint2.x)
        let x2 = abs(tempPoint1.y-tempPoint2.y)
        var len = Int(sqrt(pow(x1, 2) + pow(x2,2))*10)
        
        // 如果仅仅点击一下
        if len == 0 {
            let zeroPath = UIBezierPath(arcCenter: points[1], radius: brushWidth/2, startAngle: 0, endAngle: CGFloat(M_PI)*2.0, clockwise: true)
            brushColor.setFill()
            zeroPath.fill()
            
            // 绘图
            maskImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return
        }
        
        // 如果距离过短，直接画线
        if len < 1 {
            let zeroPath = UIBezierPath()
            zeroPath.move(to: tempPoint1)
            zeroPath.addLine(to: tempPoint2)
            
            // 画线
            zeroPath.lineWidth = brushWidth
            zeroPath.lineCapStyle = .round
            zeroPath.lineJoinStyle = .round
            zeroPath.stroke()
            
            maskImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return
        }
        
        // 获取贝塞尔点集
        let curvePoints = ScrawlView.curveFactorization(fromPoint: tempPoint1, toPoint: tempPoint2, controlPoints: [points[1]], count: &len)
        
        // 画每条线段
        var lastPoint:CGPoint = tempPoint1
        for i in 0..<len+1
        {
            let bPath = UIBezierPath()
            bPath.move(to: lastPoint)
            
            // 省略多余的点
            let delta = sqrt(pow(curvePoints[i].x-lastPoint.x, 2) + pow(curvePoints[i].y-lastPoint.y, 2))
            if delta < 1 {continue}
            
            lastPoint = CGPoint.init(x: curvePoints[i].x, y: curvePoints[i].y)
            
            bPath.addLine(to: CGPoint.init(x: curvePoints[i].x, y: curvePoints[i].y))
            
            // 画线
            bPath.lineWidth = brushWidth
            bPath.lineCapStyle = .round
            bPath.lineJoinStyle = .round
            bPath.stroke()
        }
        
        // 保存图片
        
        let pointCount = Int(sqrt(pow(tempPoint2.x-points[2].x,2)+pow(tempPoint2.y-points[2].y,2)))*2
        let delX = (tempPoint2.x-points[2].x)/CGFloat(pointCount)
        let delY = (tempPoint2.y-points[2].y)/CGFloat(pointCount)
        
        //         尾部线段
        for _ in 0..<pointCount
        {
            let bpath = UIBezierPath()
            bpath.move(to: lastPoint)
            
            let newPoint = CGPoint.init(x: lastPoint.x-delX, y: lastPoint.y-delY)
            lastPoint = newPoint
            
            bpath.addLine(to: newPoint)
            
            // 画线
            bpath.lineWidth = brushWidth
            bpath.lineCapStyle = .round
            bpath.lineJoinStyle = .round
            bpath.stroke()
        }
        
        maskImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
}

// 触摸事件
extension ScrawlView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let p = touch!.location(in: self)
        setOriginal(point: p)
        comparePoint(point: p)
        
        points = [p,p,p]
        self.addSubview(maskImageView)
        changeImage()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let p = touch!.location(in: self)
        comparePoint(point: p)
        points = [points[1],points[2],p]
        changeImage()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.waitTimeout()
    }
    
    func waitTimeout() {

        let compenent = ScrawlCompenentModel()
        compenent.frame = self.wordRect
        let rect = CGRect.init(x: self.wordRect.origin.x*UIScreen.main.scale, y: self.wordRect.origin.y*UIScreen.main.scale, width: self.wordRect.size.width*UIScreen.main.scale, height: self.wordRect.size.height*UIScreen.main.scale)
        compenent.image = maskImageView.image!.imageCut(rect)
        self.addImageView(image: compenent)
        maskImageView.image = UIColor.clear.image()
    }
    
    func setOriginal(point: CGPoint) {
        minX = point.x
        minY = point.y
        maxX = minX
        maxY = minY
    }
    //绘图所在区域
    func comparePoint(point: CGPoint) {
        if point.x < minX { minX = point.x }
        if point.y < minY { minY = point.y }
        if point.x > maxX { maxX = point.x }
        if point.y > maxY { maxY = point.y }
        wordRect = CGRect.init(x: self.minX - brushWidth, y: self.minY - brushWidth, width: self.maxX-self.minX + brushWidth*2, height: self.maxY - self.minY + brushWidth*2)
    }
}

/**
 *分解贝塞尔曲线
 */
extension ScrawlView {
    
    /**
     fromPoint:起始点
     toPoint:终止点
     controlPoints:控制点数组
     count:分解数量
     返回:分解的点集
     */
    class func curveFactorization(fromPoint:CGPoint, toPoint: CGPoint, controlPoints:[CGPoint], count:inout Int) -> [CGPoint] {
        
        //如果分解数量为0，生成默认分解数量
        if count == 0 {
            let x1 = abs(fromPoint.x-toPoint.x)
            let x2 = abs(fromPoint.y-toPoint.y)
            count = Int(sqrt(pow(x1, 2) + pow(x2,2)))
        }
        
        // 贝赛尔曲线的计算
        var s:CGFloat = 0.0
        var t:[CGFloat] = [CGFloat]()
        let pc:CGFloat = 1/CGFloat(count)
        
        let power = controlPoints.count + 1
        
        for _ in 0...count+1 {t.append(s);s=s+pc}
        
        var newPoint:[CGPoint] = [CGPoint]()
        
        for i in 0...count+1 {
            
            var resultX = fromPoint.x * bezMaker(n: power, k:0, t:t[i])
                + toPoint.x * bezMaker(n: power, k:power, t:t[i])
            
            for j in 1...power-1 {
                resultX += controlPoints[j-1].x * bezMaker(n: power, k:j, t:t[i])
            }
            
            var resultY = fromPoint.y * bezMaker(n: power, k:0, t:t[i])
                + toPoint.y * bezMaker(n: power, k:power, t:t[i])
            
            for j in 1...power-1 {
                resultY += controlPoints[j-1].y * bezMaker(n: power, k:j, t:t[i])
            }
            
            newPoint.append(CGPoint.init(x: resultX, y: resultY))
            
        }
        
        return newPoint
    }
    
    private class func comp(n:Int, k:Int) -> CGFloat{
        var s1:Int = 1
        var s2:Int = 1
        
        if k == 0 {return 1}
        
        for i in stride(from: n, through: n-k+1, by: -1) {
            s1=s1*i
        }
        for i in stride(from: k, through: 2, by: -1) {
            s2=s2*i
        }
        
        return CGFloat(s1/s2)
    }
    
    private class func realPow(n:CGFloat, k:Int) -> CGFloat{
        if k==0 {return 1.0}
        return pow(n, CGFloat(k))
    }
    
    private class func bezMaker(n:Int, k:Int, t:CGFloat) -> CGFloat{
        return comp(n: n, k: k) * realPow(n: 1-t, k: n-k) * realPow(n: t, k: k)
    }
    
    func addImageView(image: ScrawlCompenentModel) -> Void {
        (self.undoManager?.prepare(withInvocationTarget: self) as AnyObject).removeImageView(image: image)
        compenents.append(image)
        self.setNeedsDisplay()
    }
    
    func removeImageView(image: ScrawlCompenentModel) -> Void {
        if compenents.contains(image) {
            (self.undoManager?.prepare(withInvocationTarget: self) as AnyObject).addImageView(image: image)
            compenents.remove(at: compenents.index(of: image)!)
            self.setNeedsDisplay()
        }
    }
    
    func undo() -> Void {
        if undoManager!.canUndo {
            undoManager?.undo()
        }
    }
    
    func redo() -> Void {
        if undoManager!.canRedo {
            undoManager?.redo()
        }
    }
}

