//
//  CoreGraphicsTestController.m
//  Layer
//
//  Created by ldc on 2017/8/21.
//  Copyright © 2017年 HPRT. All rights reserved.
//

#import "CoreGraphicsTestController.h"

@interface CoreGraphicsTestController ()

@end

@implementation CoreGraphicsTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)dismissAction:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
