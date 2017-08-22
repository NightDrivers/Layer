//
//  BitMapTestController.m
//  Layer
//
//  Created by ldc on 2017/7/5.
//  Copyright © 2017年 HPRT. All rights reserved.
//

#import "BitMapTestController.h"
#import "UIImage+fix.h"

//简单处理32位像素的宏。为了得到红色通道的值，需要先得到前8位。为了得到其它的颜色通道值，需要进行位移截取。
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )

@interface BitMapTestController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UISlider    *slider;

@end

@implementation BitMapTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UISlider *)slider {
    
    if (!_slider) {
        _slider = [UISlider new];
        [_slider addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        [self.view addSubview:_slider];
    }
    return _slider;
}

- (void)sliderAction {
    
    [self test:[UIImage imageNamed:@"1"]];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.imageView.frame = self.view.bounds;
//    [self test:[UIImage imageNamed:@"1"]];
    self.slider.frame = CGRectMake(40, self.view.bounds.size.height - 100, self.view.bounds.size.width - 80, 100);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = self;
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self test:[(UIImage *)info[UIImagePickerControllerOriginalImage] fixOrientation]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)test:(UIImage *)image {
    
    NSUInteger width = CGImageGetWidth(image.CGImage);
    NSUInteger height = CGImageGetHeight(image.CGImage);
    
    UIImage *image1 = [UIImage imageNamed:@"2"];
    NSUInteger width1 = CGImageGetWidth(image1.CGImage);
    NSUInteger height1 = CGImageGetHeight(image1.CGImage);
    
    UInt32 *pixels = calloc(width*height, sizeof(UInt32));
    UInt32 *pixels1 = calloc(width1*height1, sizeof(UInt32));
    NSUInteger bitsPerComponent = 8;
    NSInteger bytesPerRow = width*4;
    NSInteger bytesPerRow1 = width1*4;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGColorSpaceRef space1 = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, space, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    
    CGContextRef context1 = CGBitmapContextCreate(pixels1, width1, height1, bitsPerComponent, bytesPerRow1, space1, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context1, CGRectMake(0, 0, width1, height1), image1.CGImage);
    
    UInt32 *index = pixels;
    UInt32 sum = 0;
    for (NSInteger i=0; i<width*height; i++) {
        UInt32 color = *index;
        UInt32 gray = (unsigned char)(R(color)*0.29891 + G(color)*0.58661 + B(color)*0.11448);
        sum += gray;
        index++;
    }
    UInt32 M = sum/width/height;
    
    for (NSInteger i=0; i<height; i++) {
        for (NSInteger j=0; j<width; j++) {
            UInt32 color = *pixels;

//            UInt32 temp = 0;
            
//            UInt32 newR = R(color)*0.5 + 0xff*0.5;
//            UInt32 newG = G(color)*0.5 + 0xff*0.5;
//            UInt32 newB = B(color)*0.5 + 0xff*0.5;
//            temp |= 0xff << 24;
//            temp |= newB << 16;
//            temp |= newG << 8;
//            temp |= newR ;
//            NSLog(@"%x--%x",color,temp);
            if (R(color) + G(color) + B(color) > 128*3) {
                *pixels = 0xffffffff;
            }else {
                *pixels = 0xff000000;
            }
//            *pixels = temp;
            pixels++;
            pixels1++;
////            NSLog(@"*****");
            
//            if (i<height1+600&&j<width1&&i>600) {
//                UInt32 color1 = *pixels1;
//                float rate = self.slider.value;
//                UInt32 temp = 0;
//                UInt32 newR = R(color)*rate + R(color1)*(1 - rate);
//                UInt32 newG = G(color)*rate + G(color1)*(1 - rate);
//                UInt32 newB = B(color)*rate + B(color1)*(1 - rate);
////                NSLog(@"%x-%x-%x-%x-%x-%x",R(color),G(color),B(color),R(color1),G(color1),B(color1));
//                temp |= 0xff << 24;
//                temp |= newB << 16;
//                temp |= newG << 8;
//                temp |= newR ;
//                *pixels = temp;
//                pixels1++;
//            }
//            pixels++;
        }
    }
    self.imageView.image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGColorSpaceRelease(space);
    CGContextRelease(context);
    
    
}

@end
