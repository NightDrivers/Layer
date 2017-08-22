//
//  HomeController.h
//  Layer
//
//  Created by ldc on 2017/7/5.
//  Copyright © 2017年 HPRT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeController : UIViewController

@end

@interface ReceiverModel: NSObject

@property (nonatomic, weak) id target;

@property (nonatomic, assign) SEL action;

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithName:(NSString *)name target:(id)target action:(SEL) action;

@end
