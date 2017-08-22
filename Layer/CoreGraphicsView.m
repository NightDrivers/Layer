//
//  CoreGraphicsView.m
//  Layer
//
//  Created by ldc on 2017/8/21.
//  Copyright © 2017年 HPRT. All rights reserved.
//

#import "CoreGraphicsView.h"

@implementation CoreGraphicsView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor redColor] setFill];
    [[UIColor magentaColor] setStroke];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(100, 100, 100, 100)];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextDrawPath(context, kCGPathEOFill);
}

@end
