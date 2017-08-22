//
//  UIImage+fix.h
//  Layer
//
//  Created by ldc on 2017/7/6.
//  Copyright © 2017年 HPRT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (fix)

- (UIImage *)fixOrientation;

- (UIImage *)imageCut:(CGRect)rect;

@end
