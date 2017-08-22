//
//  PTSliderView.swift
//  Layer
//
//  Created by ldc on 2017/8/4.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

enum SliderPosition: String {
    case
    left,
    center
}

protocol PTSliderViewDelegate: NSObjectProtocol {
    
    func slider(_ sliderView: PTSliderView,sliding value: CGFloat) -> Void
    
    func slider(_ sliderView: PTSliderView,slided value: CGFloat) -> Void
}

class PTSliderView: UIView {
    
    var borderShapeLayer: CAShapeLayer!
    var slider: UIView!
    var valueView: UIView!
    weak var delegate: PTSliderViewDelegate?
    
    var sliderWidth: CGFloat = 4
    var themeColor = UIColor.cyan
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 1
    var defaultSliderPosition: SliderPosition!
    //计算滑块值用的总长度
    var slideLength: CGFloat!

    init(frame: CGRect,_ position: SliderPosition) {
        super.init(frame: frame)
        defaultSliderPosition = position
        initBorderLayer(frame: frame)
        initSlider(frame: frame, position)
        initValueView(frame: frame, .left)
        slideLength = frame.size.width - sliderWidth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initBorderLayer(frame: CGRect) -> Void {
        
        borderShapeLayer = CAShapeLayer()
        borderShapeLayer.frame = CGRect.init(x: 0, y: 6, width: frame.size.width, height: frame.size.height - 12)
        borderShapeLayer.lineWidth = 1
        borderShapeLayer.fillColor = UIColor.clear.cgColor
        borderShapeLayer.strokeColor = themeColor.cgColor
        borderShapeLayer.path = UIBezierPath.init(rect: borderShapeLayer.bounds).cgPath
        layer.addSublayer(borderShapeLayer)
    }
    
    func initSlider(frame: CGRect,_ position: SliderPosition) -> Void {
        
        slider = UIView.init(frame: CGRect.init(x: 0, y: 1, width: sliderWidth, height: frame.size.height - 2))
        if position == .left {
            
        }else if position == .center {
            slider.center = CGPoint.init(x: bounds.width/2, y: bounds.height/2)
        }
        slider.layer.borderWidth = 1
        slider.layer.borderColor = themeColor.cgColor
        slider.layer.cornerRadius = sliderWidth/2
        slider.layer.masksToBounds = true
        addSubview(slider)
    }
    
    func initValueView(frame: CGRect,_ postion: SliderPosition) -> Void {
        
        valueView = UIView.init(frame: CGRect.init(x: 0, y: 6, width: 0, height: frame.size.height - 12))
        valueView.backgroundColor = themeColor
        addSubview(valueView)
    }
    
    func getCurrentValue() -> CGFloat {
        
        let positionX = self.slider.center.x - sliderWidth/2
        return positionX/self.slideLength*(maxValue - minValue) + minValue
    }
    
    func setValueView(with postion: SliderPosition) -> Void {
        
        if postion == .left {
            var tempFrame = valueView.frame
            tempFrame.size.width = self.slider.frame.origin.x
            valueView.frame = tempFrame
        }else if postion == .center {
            let sliderPositionToCenter = self.slider.center.x - bounds.width/2
            if abs(sliderPositionToCenter) <= sliderWidth {
                
                var tempFrame = valueView.frame
                tempFrame.size.width = 0
                valueView.frame = tempFrame
            }else {
                
                if sliderPositionToCenter > 0 {
                    
                    var tempFrame = valueView.frame
                    tempFrame.origin.x = bounds.width/2
                    tempFrame.size.width = self.slider.frame.origin.x - bounds.width/2
                    valueView.frame = tempFrame
                }else {
                    
                    var tempFrame = valueView.frame
                    tempFrame.origin.x = self.slider.frame.origin.x + self.slider.frame.width
                    tempFrame.size.width = bounds.width/2 - tempFrame.origin.x
                    valueView.frame = tempFrame
                }
            }
        }
    }
}

extension PTSliderView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if slider.frame.contains(point) {
            return true
        }else {
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let preLocation = touch.previousLocation(in: self)
        let Xoffset = location.x - preLocation.x
        if slider.frame.origin.x + Xoffset < 0 || slider.frame.origin.x + Xoffset + sliderWidth > bounds.width {
            return
        }
        var tempFrame = slider.frame
        tempFrame.origin.x = tempFrame.origin.x + Xoffset
        slider.frame = tempFrame
        setValueView(with: defaultSliderPosition)
        delegate?.slider(self, sliding: getCurrentValue())
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let preLocation = touch.previousLocation(in: self)
        if preLocation != location {
            
            delegate?.slider(self, slided: getCurrentValue())
        }
    }
}
