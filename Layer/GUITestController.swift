//
//  GUITestController.swift
//  Layer
//
//  Created by ldc on 2017/8/9.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class GUITestController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = UIImage.init(named: "2.png") {
            let filter = GPUImageEmbossFilter()
            filter.intensity = 0.5
            image.image(withFilter: filter, { [weak self](image) in
                self?.imageView.image = image
            })
        }
        
        if let image = UIImage.init(named: "2.png") {
            let filter = GPUImageEmbossFilter()
            filter.intensity = 1
            image.image(withFilter: filter, { [weak self](image) in
                self?.imageView1.image = image
            })
        }
        
        slider.minimumValue = 0
        slider.maximumValue = 257
        slider.value = 0
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        
//        imageView1.image = UIImage.init(named: "2.png")?.image(withBrightness: CGFloat(sender.value))
//        imageView1.image = UIImage.init(named: "2.png")?.image(withContrast: CGFloat(sender.value))
//        imageView1.image = UIImage.init(named: "2.png")?.image(withSharpness: CGFloat(sender.value))
//        imageView1.image = UIImage.init(named: "2.png")?.image(withGamma: CGFloat(sender.value))
//        imageView1.image = UIImage.init(named: "2.png")?.image(withHue: CGFloat(sender.value))
        imageView1.image = UIImage.init(named: "2.png")?.image(withColorLevel: NSInteger(sender.value))
    }
}

extension UIImage {
    
    func image(withFilter filter: GPUImageFilter) -> UIImage? {
        
        filter.forceProcessing(at: self.size)
        filter.useNextFrameForImageCapture()
        let imagePicture = GPUImagePicture.init(image: self)
        imagePicture?.addTarget(filter)
        imagePicture?.processImage()
        let newImage = filter.imageFromCurrentFramebuffer()
        return newImage
    }
    
    func image(withFilter filter: GPUImageFilter,_ closure:((UIImage?) -> Void)?) -> Void {
        filter.forceProcessing(at: self.size)
        filter.useNextFrameForImageCapture()
        let imagePicture = GPUImagePicture.init(image: self)
        imagePicture?.addTarget(filter)
        imagePicture?.processImage(completionHandler: { 
            let image = filter.imageFromCurrentFramebuffer()
            closure?(image)
        })
    }
    //修改图片亮度
    func image(withBrightness brightness: CGFloat) -> UIImage? {
        
        if brightness > 1 || brightness < -1 {
            
            return nil
        }
        let brightFilter = GPUImageBrightnessFilter()
        //默认0
        brightFilter.brightness = brightness
        return image(withFilter: brightFilter)
    }
    //修改图像对比度
    func image(withContrast contrast: CGFloat) -> UIImage? {
        
        if contrast > 4 || contrast < 0 {
            
            return nil
        }
        let contrastFilter = GPUImageContrastFilter()
        //默认1
        contrastFilter.contrast = contrast
        return image(withFilter: contrastFilter)
    }
    //修改图像锐度
    func image(withSharpness sharpness: CGFloat) -> UIImage? {
        
        if sharpness > 4 || sharpness < -4 {
            
            return nil
        }
        let sharpenFilter = GPUImageSharpenFilter()
        //默认0
        sharpenFilter.sharpness = sharpness
        return image(withFilter: sharpenFilter)
    }
    //修改图像伽马值
    func image(withGamma gamma: CGFloat) -> UIImage? {
        
        if gamma > 3 || gamma < 0 {
            return nil
        }
        let gammaFilter = GPUImageGammaFilter()
        //默认1
        gammaFilter.gamma = gamma
        return image(withFilter: gammaFilter)
    }
    //修改图像色度
    func image(withHue hue: CGFloat) -> UIImage? {
        //测试-100~100没问题、hue边缘值未知、默认值似乎是0
        let hueFilter = GPUImageHueFilter()
        hueFilter.hue = hue
        return image(withFilter: hueFilter)
    }
    //褐色复古
    func sepiaImage() -> UIImage? {
        
        return self.image(withFilter: GPUImageSepiaFilter())
    }
    //颜色反转
    func colorInvertImage() -> UIImage? {
        
        return image(withFilter: GPUImageColorInvertFilter())
    }
    //灰阶图片
    func grayscaleImage() -> UIImage? {
        
        return image(withFilter: GPUImageGrayscaleFilter())
    }
    //素描效果
    func sketchImage() -> UIImage? {
        
        return image(withFilter: GPUImageSketchFilter())
    }
    //box模糊
    func boxBlurImage() -> UIImage? {
        
        return image(withFilter: GPUImageBoxBlurFilter())
    }
    //中值模糊
    func medianBlurImage() -> UIImage? {
        
        return image(withFilter: GPUImageMedianFilter())
    }
    //浮雕效果
    func embossImage() -> UIImage? {
        //intensity 0~4 默认1
        return image(withFilter: GPUImageEmbossFilter())
    }
    
    
    //非最大抑制，只显示亮度最高的像素，其他为黑
    func nonMaxmunSuppressImage() -> UIImage? {
        
        return image(withFilter: GPUImageNonMaximumSuppressionFilter())
    }
    //prewitt边缘检测
    func prewittEdgeDetectionImage() -> UIImage? {
        
        return image(withFilter: GPUImagePrewittEdgeDetectionFilter())
    }
    //XYDerivative边缘检测，画面以蓝色为主，绿色为边缘，带彩色
    func xYDerivativeImage() -> UIImage? {
        
        return image(withFilter: GPUImagePrewittEdgeDetectionFilter())
    }
    //图像黑白化，并有大量噪点
    func localBinaryPatternImage() -> UIImage? {
        
        return image(withFilter: GPUImageLocalBinaryPatternFilter())
    }
    //阀值素描，形成有噪点的素描
    func thresholdSketchImage() -> UIImage? {
        
        return image(withFilter: GPUImageThresholdSketchFilter())
    }
    //色彩丢失，模糊（类似监控摄像效果）
    func colorPackingImage() -> UIImage? {
        
        return image(withFilter: GPUImageColorPackingFilter())
    }
    //晕影，形成黑色圆形边缘，突出中间图像的效果
    func vignetteImage() -> UIImage? {
        
        return image(withFilter: GPUImageVignetteFilter())
    }
    //水晶球效果
    func glassSphereImage() -> UIImage? {
        
        return image(withFilter: GPUImageGlassSphereFilter())
    }
    //色调分离，形成噪点效果
    func image(withColorLevel colorLevel: NSInteger) -> UIImage? {
        
        let posterizeFilter = GPUImagePosterizeFilter()
        return image(withFilter: posterizeFilter)
    }
    
    func Image() -> UIImage? {
        
        let filter = GPUImageAlphaBlendFilter()
        return image(withFilter: filter)
    }
}
