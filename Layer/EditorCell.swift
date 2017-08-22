//
//  EditorCell.swift
//  Layer
//
//  Created by ldc on 2017/7/12.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

// MARK: cell超出画布bug

enum EditorCellTouchType {
    case
    translation,
    zoomAndRotate,
    zoom,
    rotate,
    delete,
    widthZoom,
    heightZoom,
    none
}

class AffineTransformTuple: NSObject {
    
    var translation = CGAffineTransform.identity
    var scale = CGAffineTransform.identity
    var rotate = CGAffineTransform.identity
    
    override init() {
        
    }
    
    init(_ translation: CGAffineTransform,_ scale: CGAffineTransform,_ rotate: CGAffineTransform) {
        
        self.translation = translation
        self.scale = scale
        self.rotate = rotate
    }
    
    func concatenatingTransform() -> CGAffineTransform {

        return scale.concatenating(rotate).concatenating(translation)
    }
}

typealias EditorCellOperationClosure = (_ cell: EditorCell) -> Void

class EditorCell: UIView {

    let extensionEdges: CGFloat = -10
    var touchType: EditorCellTouchType = .none
    var isSelected: Bool = false {
        
        didSet {
            
            setNeedsDisplay()
        }
    }
    weak var delegate: EditorCellDelegate?
    var constFrame: CGRect = CGRect.zero
    var touchBeginAffineTuple: AffineTransformTuple = AffineTransformTuple()
    var affineTransformTuple: AffineTransformTuple = AffineTransformTuple()
    var touchBeginFrame = CGRect.zero
    var tapClosureWhenSelected: EditorCellOperationClosure?
    var doubleTapClosureWhenSelected: EditorCellOperationClosure?
    var deleteClosure: EditorCellOperationClosure?
    
    var deleteView: UIImageView?
    var zoomAndRotateView: UIImageView?
    var borderLayer: CAShapeLayer?
    var timer: Timer?
    let tapTimeSpace: TimeInterval = 0.3
    
    init(with frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        constFrame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func whenTapInSelected(_ closure: EditorCellOperationClosure?) -> Void {
        
        tapClosureWhenSelected = closure
    }
    
    func whenDoubleTapInSelected(_ closure: EditorCellOperationClosure?) -> Void {
        
        doubleTapClosureWhenSelected = closure
    }
    
    func whenDeleteCell(_ closure: EditorCellOperationClosure?) -> Void {
        
        deleteClosure = closure
    }
    
    deinit {
        print("没有内存泄漏")
    }
    
//    func updateEditorCellModel() -> Void {
//        
//        let locationScaleTransform = affineTransformTuple.scale.concatenating(affineTransformTuple.translation)
//        let originAffined = constFrame.origin.transform(locationScaleTransform, center)
//        let rightTopPointAffined = CGPoint.init(x: constFrame.maxX, y: constFrame.minY).transform(locationScaleTransform, center)
//        let leftBottomPointAffined = CGPoint.init(x: constFrame.minX, y: constFrame.maxY).transform(locationScaleTransform, center)
//        editorCellModel.paperFrame = editorCellModel.convertToPaperFrame(CGRect.init(x: originAffined.x, y: originAffined.y, width: rightTopPointAffined.x - originAffined.x, height: leftBottomPointAffined.y - originAffined.y))
//        editorCellModel.rotation = affineTransformTuple.rotate.convertToRotate(point: center)
//    }
    
    override func draw(_ rect: CGRect) {
        
        if isSelected {
            
            layer.addSublayer(lazyBorderLayer())
            addSubview(lazyDeleteView())
            addSubview(lazyZoomAndRotateView())
            
            lazyBorderLayer().frame = bounds
            lazyBorderLayer().path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 2).cgPath
            lazyBorderLayer().lineWidth = 1.0/affineTransformTuple.scale.a
            lazyDeleteView().bounds = CGRect.init(x: 0, y: 0, width: abs(extensionEdges)*2/affineTransformTuple.scale.a, height: abs(extensionEdges)*2/affineTransformTuple.scale.d)
            lazyDeleteView().center = CGPoint.init(x: 0, y: 0)
            lazyZoomAndRotateView().bounds = CGRect.init(x: 0, y: 0, width: abs(extensionEdges)*2/affineTransformTuple.scale.a, height: abs(extensionEdges)*2/affineTransformTuple.scale.d)
            lazyZoomAndRotateView().center = CGPoint.init(x: bounds.size.width, y: bounds.size.height)
            print("\(lazyZoomAndRotateView().bounds)  \(lazyDeleteView().bounds)")
        }else {
            
            lazyBorderLayer().removeFromSuperlayer()
            lazyZoomAndRotateView().removeFromSuperview()
            lazyDeleteView().removeFromSuperview()
        }
    }
    
    func lazyDeleteView() -> UIImageView {
        
        if let _ = deleteView {
            return deleteView!
        }else {
            let temp = UIImageView()
            temp.frame = CGRect.init(x: extensionEdges, y: extensionEdges, width: abs(extensionEdges)*2, height: abs(extensionEdges)*2)
            temp.backgroundColor = UIColor.red
//            temp.image = #imageLiteral(resourceName: "btn_close")
            deleteView = temp
            return temp
        }
    }
    
    func lazyZoomAndRotateView() -> UIImageView {
        
        if let _ = zoomAndRotateView {
            return zoomAndRotateView!
        }else {
            let temp = UIImageView()
            temp.frame = CGRect.init(x: bounds.width + extensionEdges, y: bounds.height + extensionEdges, width: abs(extensionEdges)*2, height: abs(extensionEdges)*2)
            temp.backgroundColor = UIColor.red
//            temp.image = #imageLiteral(resourceName: "btn_zoom")
            zoomAndRotateView = temp
            return temp
        }
    }
    
    func lazyBorderLayer() -> CAShapeLayer {
        
        if let _ = borderLayer {
            
            return borderLayer!
        }else {
            let layer = CAShapeLayer.init()
            layer.frame = self.bounds
            layer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 2).cgPath
            layer.lineWidth = 1
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = UIColor.red.cgColor
            borderLayer = layer
            return layer
        }
    }
}

extension EditorCell {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let contained = bounds.insetBy(dx: extensionEdges*2, dy: extensionEdges*2).contains(point)
        return contained
    }
    
    //根据仿射判断图形是否超出画布
    func isOutBoundsOrTooSmall(_ transform: CGAffineTransform) -> Bool {
        let centerPoint = CGPoint.init(x: (constFrame.minX + constFrame.maxX)/2, y: (constFrame.minY + constFrame.maxY)/2)
        let leftTopPoint = CGPoint.init(x: constFrame.minX, y: constFrame.minY).transform(transform, centerPoint)
        let leftBottomPoint = CGPoint.init(x: constFrame.minX, y: constFrame.maxY).transform(transform, centerPoint)
        let rightTopPoint = CGPoint.init(x: constFrame.maxX, y: constFrame.minY).transform(transform, centerPoint)
        let rightBootomPoint = CGPoint.init(x: constFrame.maxX, y: constFrame.maxY).transform(transform, centerPoint)
        if let temp = superview {
            if leftTopPoint.x < 0 || leftTopPoint.y < 0 || leftBottomPoint.x < 0 || leftBottomPoint.y > temp.frame.height || rightTopPoint.x > temp.frame.width || rightTopPoint.y < 0 || rightBootomPoint.x > temp.frame.width || rightBootomPoint.y > temp.frame.height || abs(rightTopPoint.x - leftTopPoint.x) < 50 || abs(leftBottomPoint.y - leftTopPoint.y) < 50 {
                
                return true
            }else {
                return false
            }
        }
        return true
    }
    
    func zoomWidthRightRegion() -> CGRect {
        
        return CGRect.init(x: bounds.width - abs(extensionEdges)*2/affineTransformTuple.scale.a, y: 0, width: abs(extensionEdges)*4/affineTransformTuple.scale.a, height: bounds.height)
    }
    
    func zoomWidthLeftRegion() -> CGRect {
        
        return CGRect.init(x: -abs(extensionEdges)*2/affineTransformTuple.scale.a, y: 0, width: abs(extensionEdges)*4/affineTransformTuple.scale.a, height: bounds.height)
    }
    
    func zoomHeightTopRegion() -> CGRect {
        
        return CGRect.init(x:  0, y: -abs(extensionEdges)*2/affineTransformTuple.scale.d, width: bounds.width, height: abs(extensionEdges)*4/affineTransformTuple.scale.d)
    }
    
    func zoomHeightBottomRegion() -> CGRect {
        
        return CGRect.init(x: 0, y: bounds.height - abs(extensionEdges)*2/affineTransformTuple.scale.d, width: bounds.width, height: abs(extensionEdges)*4/affineTransformTuple.scale.d)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !isSelected {
            
        }else {
            let touch = touches.first!
            let location = touch.location(in: self)
            if CGRect.init(with: lazyDeleteView().center, 40, 40).contains(location) {
                touchType = .delete
            }else if CGRect.init(with: lazyZoomAndRotateView().center, 40, 40).contains(location) {
                touchType = .zoomAndRotate
            }else if zoomWidthLeftRegion().contains(location) || zoomWidthRightRegion().contains(location) {
                touchType = .widthZoom
                touchBeginFrame = constFrame
            }else if zoomHeightTopRegion().contains(location) || zoomHeightBottomRegion().contains(location) {
                touchType = .heightZoom
                touchBeginFrame = constFrame
            }else if bounds.contains(location) {
                touchType = .translation
            }else {
                touchType = .none
            }
            touchBeginAffineTuple = AffineTransformTuple.init(affineTransformTuple.translation, affineTransformTuple.scale, affineTransformTuple.rotate)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: superview!)
        let preLocation = touch.previousLocation(in: superview!)
        if touchType == .translation {
            
            let move = CGVector.init(dx: location.x - preLocation.x, dy: location.y - preLocation.y)
            let tempTransform = affineTransformTuple.translation.translatedBy(x: move.dx, y: move.dy)
            if isOutBoundsOrTooSmall(AffineTransformTuple.init(tempTransform, affineTransformTuple.scale, affineTransformTuple.rotate).concatenatingTransform()) {
                return
            }
            affineTransformTuple.translation = tempTransform
        }else {
            
            let constCenter = CGPoint.init(x: (constFrame.maxX + constFrame.minX)/2, y: (constFrame.maxY + constFrame.minY)/2)
            let transformedCenter = CGPoint.init(x: CGPoint.zero.xTransform(affineTransformTuple.concatenatingTransform()) + constCenter.x, y: CGPoint.zero.yTransform(affineTransformTuple.concatenatingTransform()) + constCenter.y)
            let vectorBase = CGPoint.init(x: preLocation.x - transformedCenter.x, y: preLocation.y - transformedCenter.y)
            let vectorCenterToNow = CGPoint.init(x: location.x - transformedCenter.x, y: location.y - transformedCenter.y)
            
            if touchType == .zoom{
                
                let tempScaleTransform = affineTransformTuple.scale.scaledBy(x: vectorCenterToNow.x/vectorBase.x.noZeroValue(), y: vectorCenterToNow.y/vectorBase.y.noZeroValue())
                if isOutBoundsOrTooSmall(AffineTransformTuple.init(affineTransformTuple.translation, tempScaleTransform, affineTransformTuple.rotate).concatenatingTransform()) {
                    return;
                }
                affineTransformTuple.scale = tempScaleTransform
                
            }else if touchType == .rotate {
                
                let vectorBaseLength = sqrt(pow(vectorBase.x, 2) + pow(vectorBase.y, 2))
                let angel = acos((vectorCenterToNow.x*vectorBase.x + vectorCenterToNow.y*vectorBase.y)/vectorBaseLength/sqrt(pow(vectorCenterToNow.x, 2) + pow(vectorCenterToNow.y, 2)).noZeroValue())
                let vectorBaseRotate90Clockwise = vectorBase.rotateClockwise90()
                let closewiseFlag = vectorCenterToNow.x*vectorBaseRotate90Clockwise.x + vectorCenterToNow.y*vectorBaseRotate90Clockwise.y > 0 ? 1 : -1
                //形变属性修改会导致frame属性值变化
                let temoRotateTransform = affineTransformTuple.rotate.concatenating(CGAffineTransform.init(rotationAngle: angel*CGFloat(closewiseFlag)))
                if isOutBoundsOrTooSmall(AffineTransformTuple.init(affineTransformTuple.translation, affineTransformTuple.scale, temoRotateTransform).concatenatingTransform()) {
                    return
                }
                affineTransformTuple.rotate = temoRotateTransform
            }else if touchType == .zoomAndRotate {
                
                let vectorBaseLength = sqrt(pow(vectorBase.x, 2) + pow(vectorBase.y, 2))
                if __inline_isnand(Double(vectorBaseLength)) != 0 {
                    return
                }
                let projectionLength = (vectorBase.x*vectorCenterToNow.x + vectorBase.y*vectorCenterToNow.y)/vectorBaseLength
                let vectorProjection = CGPoint.init(x: vectorBase.x*projectionLength/vectorBaseLength, y: vectorBase.y*projectionLength/vectorBaseLength)
                let tempScaleTransform = affineTransformTuple.scale.scaledBy(x: (vectorProjection.x/vectorBase.x.noZeroValue()).noZeroValue(), y: (vectorProjection.y/vectorBase.y.noZeroValue()).noZeroValue())
                
                //MARK: 当出现运算误差导致acos 的参数数大于1或小于-1时 acos函数将返回NaN值，不处理将导致app崩溃
                let angel = acos((vectorCenterToNow.x*vectorBase.x + vectorCenterToNow.y*vectorBase.y)/vectorBaseLength/CGFloat(sqrt(pow(vectorCenterToNow.x, 2) + pow(vectorCenterToNow.y, 2))).noZeroValue())
                let vectorBaseRotate90Clockwise = vectorBase.rotateClockwise90()
                let closewiseFlag = vectorCenterToNow.x*vectorBaseRotate90Clockwise.x + vectorCenterToNow.y*vectorBaseRotate90Clockwise.y > 0 ? 1 : -1
                //形变属性修改会导致frame属性值变化
                var temoRotateTransform = affineTransformTuple.rotate
                if __inline_isnand(Double(angel)) == 0 {
                    temoRotateTransform = affineTransformTuple.rotate.concatenating(CGAffineTransform.init(rotationAngle: angel*CGFloat(closewiseFlag)))
                }else {
                    print("angle值为NaN,不修改角度变换值")
                }
                if isOutBoundsOrTooSmall(AffineTransformTuple.init(affineTransformTuple.translation, tempScaleTransform, temoRotateTransform).concatenatingTransform()) {
                    return
                }
                affineTransformTuple.scale = tempScaleTransform
                affineTransformTuple.rotate = temoRotateTransform
            }else if touchType == .widthZoom {
                
                let Xoffset = location.x - preLocation.x
                let Xscale  = affineTransformTuple.scale.a
                let Xchange = Xoffset*vectorBase.x/abs(vectorBase.x).noZeroValue()/Xscale
                constFrame.origin.x -= Xchange
                constFrame.size.width += Xchange*2
                if isOutBoundsOrTooSmall(AffineTransformTuple.init(affineTransformTuple.translation, affineTransformTuple.scale, affineTransformTuple.rotate).concatenatingTransform()) {
                    constFrame.origin.x += Xchange
                    constFrame.size.width -= Xchange*2
                    return
                }
                transform = CGAffineTransform.identity
                frame = constFrame
            }else if touchType == .heightZoom {
                
                let Yoffset = location.y - preLocation.y
                let Yscale  = affineTransformTuple.scale.d
                let Ychange = Yoffset*vectorBase.y/abs(vectorBase.y).noZeroValue()/Yscale
                constFrame.origin.y -= Ychange
                constFrame.size.height += Ychange*2
                if isOutBoundsOrTooSmall(AffineTransformTuple.init(affineTransformTuple.translation, affineTransformTuple.scale, affineTransformTuple.rotate).concatenatingTransform()) {
                    constFrame.origin.y += Ychange
                    constFrame.size.height -= Ychange*2
                    return
                }
                transform = CGAffineTransform.identity
                frame = constFrame
            }
        }
        transform = affineTransformTuple.concatenatingTransform()
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let preLocation = touch.previousLocation(in: self)
        if !isSelected {
            isSelected = true
            delegate?.editorSelect(self)
        }else {
            if location == preLocation {
                
                weak var temp = self
                if temp != nil {
                    if lazyDeleteView().frame.contains(location) {
                        delegate?.cellRemove(temp!)
                        deleteClosure?(temp!)
                    }else if bounds.contains(location) {
                        if let tempTimer = timer {
                            if tempTimer.isValid {
                                timer?.invalidate()
                                timer = Timer.scheduledTimer(withTimeInterval: tapTimeSpace, repeats: false, block: { [weak self](_) in
                                    self?.doubleTapClosureWhenSelected?(temp!)
                                })
                            }else {
                                timer = Timer.scheduledTimer(withTimeInterval: tapTimeSpace, repeats: false, block: { [weak self](_) in
                                    self?.tapClosureWhenSelected?(temp!)
                                })
                            }
                        }else {
                            timer = Timer.scheduledTimer(withTimeInterval: tapTimeSpace, repeats: false, block: { [weak self](_) in
                                self?.tapClosureWhenSelected?(temp!)
                            })
                        }
                    }else {
                        touchType = .none
                    }
                }
            }else {
                
                if touchType == .widthZoom || touchType == .heightZoom {
                    
                    delegate?.cellDidChangeFrame(self, touchBeginFrame, constFrame, affineTransformTuple)
                }else {
                    if touchType != .none && touchType != .delete {
                        delegate?.cell(self, constFrame, transformChange: touchBeginAffineTuple, affineTransformTuple)
                    }
                }
            }
            touchType = .none
        }
    }
}

extension CGRect {
    
    init(with center: CGPoint,_ width: CGFloat,_ height: CGFloat) {
        
        self.init()
        origin.x = center.x - width/2
        origin.y = center.y - height/2
        size.width = width
        size.height = height
    }
}

extension CGFloat {
    
    func noZeroValue() -> CGFloat {
        if self == 0 {
            return 1
        }else {
            return self
        }
    }
}

extension CGPoint {
    
    func offsetX(to point: CGPoint) -> CGFloat {
        
        return self.x - point.x;
    }
    
    func rotateClockwise90() -> CGPoint {
        
        return CGPoint.init(x: -self.y, y: self.x)
    }
    //以某个点进行仿射变换
    func transform(_ transform: CGAffineTransform,_ center: CGPoint) -> CGPoint {
        
        let tempPoint = CGPoint.init(x: self.x - center.x, y: self.y - center.y)
        return CGPoint.init(x: tempPoint.x*transform.a + tempPoint.y*transform.c + transform.tx + center.x, y: tempPoint.x*transform.b + tempPoint.y*transform.d + transform.ty + center.y)
    }
    //以原点进行仿射变换
    func transform(_ transform: CGAffineTransform) -> CGPoint {
        
        return CGPoint.init(x: self.x*transform.a + self.y*transform.c + transform.tx, y: self.x*transform.b + self.y*transform.d + transform.ty)
    }
    
    func xTransform(_ transform: CGAffineTransform) -> CGFloat {
        
        return self.x*transform.a + self.y*transform.c + transform.tx
    }
    
    func yTransform(_ transform: CGAffineTransform) -> CGFloat {
        
        return self.x*transform.b + self.y*transform.d + transform.ty
    }
}

extension CGAffineTransform {
    
    //仿射变换对应某点的旋转角度
    func convertToRotate(point: CGPoint) -> CGFloat {
        //以xAffined作为要变换的点,通过(1,0)、(0,1)确定旋转角度
        let xAffined = CGPoint.init(x: point.x + 1, y: point.y).transform(self, point)
        let vectorAffined = CGVector.init(dx: xAffined.x - point.x, dy: xAffined.y - point.y)
        let angleToX = acos(vectorAffined.dx/sqrt(pow(vectorAffined.dx, 2) + pow(vectorAffined.dy, 2)))
        let angleToYCos = vectorAffined.dy/sqrt(pow(vectorAffined.dx, 2) + pow(vectorAffined.dy, 2))
        return angleToYCos < 0 ? -angleToX : angleToX
    }
}
