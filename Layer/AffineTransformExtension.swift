//
//  AffineTransformExtension.swift
//  Layer
//
//  Created by ldc on 2017/7/20.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import Foundation

//extension CGAffineTransform {
//    
//    func convertToRotate(point: CGPoint) -> CGFloat {
//        //以xAffined作为要变换的点,通过(1,0)、(0,1)确定旋转角度
//        let xAffined = CGPoint.init(x: point.x + 1, y: point.y).transform(self, point)
//        let vectorAffined = CGVector.init(dx: xAffined.x - point.x, dy: xAffined.y - point.y)
//        let angleToX = acos(vectorAffined.dx/sqrt(pow(vectorAffined.dx, 2) + pow(vectorAffined.dy, 2)))
//        let angleToYCos = vectorAffined.dy/sqrt(pow(vectorAffined.dx, 2) + pow(vectorAffined.dy, 2))
//        return angleToYCos < 0 ? -angleToX : angleToX
//    }
//}
//
//func *(lhs: CGVector, rhs: CGVector) -> CGFloat {
//    
//    return lhs.dx*rhs.dx + lhs.dy*rhs.dy
//}
//
//extension CGVector {
//    //旋转90度
//    func rotate90(closewise: Bool) -> CGVector {
//        /**
//         建立与坐标轴一致的极坐标，原始位置为(a*cos(b),a*sin(b))
//         顺时针旋转后 a*cos(b + M_PI_2) = a*(cos(b)*cos(M_PI_2) - sin(b)*sin(M_PI_2)) = -a*sin(b)
//                    a*sin(b + M_PI_2) = a*(sin(b)*cos(M_PI_2) + cos(b)*sin(M_PI_2)) = a*cos(b)
//                    即(-a*sin(b),a*cos(b))
//        逆时针同理
//         */
//        
//        if closewise {
//            return CGVector.init(dx: -self.dy, dy: self.dx)
//        }else {
//            return CGVector.init(dx: self.dy, dy: -self.dx)
//        }
//    }
//    
//    func pointValue() -> CGPoint {
//        
//        return CGPoint.init(x: self.dx, y: self.dy)
//    }
//    
//    func length() -> CGFloat {
//        
//        return sqrt(pow(self.dx, 2) + pow(self.dy, 2))
//    }
//    // 顺时针为正 逆时针为负
//    func angle(to aimVector: CGVector) -> CGFloat {
//        
//        let directionVector = self.rotate90(closewise: true)
//        let noDirectionAngle = acos(self*aimVector/(self.length()*aimVector.length()))
//        let directionFlag: CGFloat = directionVector*aimVector/(aimVector.length()*directionVector.length()) >= 0 ? 1 : -1
//        return noDirectionAngle*directionFlag
//    }
//    
//}
//
//extension CGPoint {
//    
//    func vectorValue() -> CGVector {
//        
//        return CGVector.init(dx: self.x, dy: self.y)
//    }
//    
//    //以某个点进行仿射变换
//    func transform(_ transform: CGAffineTransform,_ center: CGPoint) -> CGPoint {
//        
//        let tempVector = CGVector.init(dx: self.x - center.x, dy: self.y - center.y)
//        return CGPoint.init(x: tempVector.pointValue().xTransform(transform) + center.x, y: tempVector.pointValue().yTransform(transform) + center.y)
//    }
//    
//    //以原点进行仿射变换
//    func transform(_ transform: CGAffineTransform) -> CGPoint {
//        
//        return CGPoint.init(x: self.xTransform(transform), y: self.yTransform(transform))
//    }
//    
//    func xTransform(_ transform: CGAffineTransform) -> CGFloat {
//        
//        return self.x*transform.a + self.y*transform.c + transform.tx
//    }
//    
//    func yTransform(_ transform: CGAffineTransform) -> CGFloat {
//        
//        return self.x*transform.b + self.y*transform.d + transform.ty
//    }
//}
