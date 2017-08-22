//
//  ShareController.swift
//  Layer
//
//  Created by ldc on 2017/8/17.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class ShareController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shareParams = NSMutableDictionary()
//        try? UIImagePNGRepresentation(UIImage.init(named: "1.png")!)!.write(to: NSURL.init(string: NSHomeDirectory() + "Documents/1.png")! as URL)
//        let path = NSHomeDirectory() + "Documents/1.png"
//        let path = Bundle.main.path(forResource: "2", ofType: "png")
//        shareParams.ssdkSetupShareParams(byText: "text", title: "title", image: SSDKImage.init(image: UIImage.init(named: "2.png")!, format: SSDKImageFormatPng, settings: nil), url: URL.init(string: "http://baidu.com"), latitude: 30, longitude: 116, objectID: nil, type: .image)
        // 微信 朋友圈 QQ好友 QQ空间(能分享、应用不存在) 微博(图片类型无链接、网页类型无图像)
        shareParams.ssdkSetupShareParams(byText: "text", images: UIImage.init(named: "2.png"), url: URL.init(string: "http://baidu.com"), title: "title", type: .auto)
//        shareParams.ssdkEnableSinaWeiboAPIShare()
//        shareParams.ssdkSetupSinaWeiboShareParams(byText: "text", title: "title", image: UIImage.init(named: "2.png"), url: URL.init(string: "http://baidu.com"), latitude: 30, longitude: 116, objectID: nil, type: .webPage)
//
        //
//        ShareSDK.share(withContentName: "ShareSDK", platform: SSDKPlatformType.subTypeWechatSession, customFields: ["text":"text","imgUrl":UIImage.init(named: "1.png")!,"url":"http://baidu.com","title":"title"]) { (responseState, info, contentEntity, error) in
//            
//            print("\(responseState)")
//            print("\(info)")
//            print("\(contentEntity)")
//            print("\(error)")
//        }
        
        ShareSDK.share(SSDKPlatformType.typeWechat, parameters: shareParams) { (responseState, info, contentEntity, error) in
            print("\(responseState)")
            print("\(info)")
            print("\(contentEntity)")
            print("\(error)")
        }
    }

}
