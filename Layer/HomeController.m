//
//  HomeController.m
//  Layer
//
//  Created by ldc on 2017/7/5.
//  Copyright © 2017年 HPRT. All rights reserved.
//

#import "HomeController.h"
#import "BitMapTestController.h"
#import "ImageProcessTestController.h"
#import "CoreGraphicsTestController.h"
#import "Layer-Swift.h"

@interface HomeController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<ReceiverModel *> *models;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"位图" target:self action:@selector(pushBitmapVC)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"图形处理" target:self action:@selector(pushImageProcessTestController)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"涂鸦" target:self action:@selector(pushScrawlTestController)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"触摸手势" target:self action:@selector(pushTouchTestController)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"编辑器" target:self action:@selector(pushEditorController)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"仿射变换" target:self action:@selector(pushAffineTransformTestController)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"滑动多项选择器" target:self action:@selector(pushScrollSegmentedViewTestController)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"文字" target:self action:@selector(pushTextController)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"照片库" target:self action:@selector(pushImageAssetsController)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"自定义滑块" target:self action:@selector(pushCustomSliderController)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"GUI测试" target:self action:@selector(pushGUITestController)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"分享测试" target:self action:@selector(pushShareController)]];
    [self.models addObject:[[ReceiverModel alloc] initWithName:@"CoreGraphics测试" target:self action:@selector(pushCoreGraphicsTestController)]];
}

- (NSMutableArray<ReceiverModel *> *)models {
    
    if (!_models) {
        _models = [NSMutableArray new];
    }
    return _models;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.models[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.models[indexPath.row].target performSelector:self.models[indexPath.row].action];
}

- (void)pushBitmapVC {
    
    [self pushController:[BitMapTestController class]];
}

- (void)pushImageProcessTestController {
    
    [self pushController:[ImageProcessTestController class]];
}

- (void)pushScrawlTestController {
    
    [self pushController:[ScrawlTestController class]];
}

- (void)pushTouchTestController {
    
    [self pushController:[TouchTestController class]];
}

- (void)pushEditorController {
    
    [self pushController:[EditorController class]];
}

- (void)pushAffineTransformTestController {
    
    [self pushController:[AffineTransformTestController class]];
}

- (void)pushScrollSegmentedViewTestController {
    
    [self pushController:[ScrollSegmentedViewTestController class]];
}

- (void)pushTextController {
    
    [self pushController:[TextController class]];
}

- (void)pushImageAssetsController {
    
    [self pushController:[ImageAssetsController class]];
}

- (void)pushCustomSliderController {
    
    [self pushController:[CustomSliderController class]];
}

- (void)pushGUITestController {
    
    [self pushController:[GUITestController class]];
}

- (void)pushShareController {
    
    [self pushController:[ShareController class]];
}

- (void)pushCoreGraphicsTestController {
    
    UIViewController* vc = [CoreGraphicsTestController new];
    [self.navigationController presentViewController:vc animated:true completion:nil];
}

- (void)pushController:(Class)className {
    
    UIViewController* vc = (UIViewController *)[className new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

@implementation ReceiverModel

- (instancetype)initWithName:(NSString *)name target:(NSString *)target action:(SEL)action {
    
    self = [super init];
    if (self) {
        self.name   = name;
        self.target = target;
        self.action = action;
    }
    return self;
}

@end
