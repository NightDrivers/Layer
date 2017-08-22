//
//  ImageProcessTestController.m
//  Layer
//
//  Created by ldc on 2017/7/6.
//  Copyright © 2017年 HPRT. All rights reserved.
//

#import "ImageProcessTestController.h"
#import "UIImage+fix.h"

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )

@interface ImageProcessTestController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (nonatomic, strong) UIImagePickerController *imagePickerVC;
@property (nonatomic, strong) UIImage *selectedImage;

@end

@implementation ImageProcessTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.alphaSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    [self.redSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    [self.greenSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    [self.blueSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)hiddenControl:(UIButton *)sender {
    
    [self setControlHidden:YES];
}

- (IBAction)showControl:(UIButton *)sender {
    
    [self setControlHidden:NO];
}

- (IBAction)cameraAction:(UIButton *)sender {
    
    self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (IBAction)photoAction:(id)sender {
    
    self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (void)setControlHidden:(BOOL)hidden {
    
    self.alphaSlider.hidden = hidden;
    self.redSlider.hidden = hidden;
    self.greenSlider.hidden = hidden;
    self.blueSlider.hidden = hidden;
    self.infoLabel.hidden = hidden;
}

- (UIImagePickerController *)imagePickerVC {
    
    if (!_imagePickerVC) {
        _imagePickerVC = [[UIImagePickerController alloc] init];
        _imagePickerVC.delegate = self;
    }
    return _imagePickerVC;
}

- (void)sliderValueChange {
    
    [self processImage:self.selectedImage];
}

- (void)processImage:(UIImage *)image {
    
    NSUInteger width = CGImageGetWidth(image.CGImage);
    NSUInteger height = CGImageGetHeight(image.CGImage);
    
    UInt32 *pixels = calloc(width*height, sizeof(UInt32));
    UInt32 *head = pixels;
    NSUInteger bitsPerComponent = 8;
    NSInteger bytesPerRow = width*4;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, space, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    UInt32 temp = *pixels;
    NSLog(@"%x",temp);
    UInt8 *pixels1 = (UInt8 *)pixels;
    for (int i = 0; i < 4; i++) {
        UInt8 temp1 = *pixels1;
        NSLog(@"%x",temp1);
        pixels1++;
    }
    for (NSInteger i=0; i<height; i++) {
        for (NSInteger j=0; j<width; j++) {
            UInt32 color = *pixels;
            float rate = 1 - self.alphaSlider.value;
            UInt32 temp = 0;
            UInt32 newR = R(color)*rate + self.redSlider.value*(1 - rate);
            UInt32 newG = G(color)*rate + self.greenSlider.value*(1 - rate);
            UInt32 newB = B(color)*rate + self.blueSlider.value*(1 - rate);
//                NSLog(@"%x-%x-%x-%x-%x-%x",R(color),G(color),B(color),R(color1),G(color1),B(color1));
            temp |= 0xff << 24;
            temp |= newB << 16;
            temp |= newG << 8;
            temp |= newR ;
            *pixels = temp;
            pixels++;
        }
    }
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    self.imageView.image = [UIImage imageWithCGImage:imageRef];
    self.infoLabel.text = [NSString stringWithFormat:@"滤镜值：%.2f红：%u绿：%u蓝：%u",self.alphaSlider.value,(unsigned int)self.redSlider.value,(unsigned int)self.greenSlider.value,(unsigned int)self.blueSlider.value];
    CGColorSpaceRelease(space);
    CGContextRelease(context);
    CGImageRelease(imageRef);
    free(head);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    self.selectedImage = [(UIImage *)info[UIImagePickerControllerOriginalImage] fixOrientation];
    self.alphaSlider.value = 0;
    self.redSlider.value = 0;
    self.greenSlider.value = 0;
    self.blueSlider.value = 0;
    [self processImage:self.selectedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    
}

@end
