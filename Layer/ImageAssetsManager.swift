//
//  ImageAssetsManager.swift
//  CardPrinter
//
//  Created by ldc on 2017/8/2.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit
import Photos

class ImageAssetsManager: NSObject {
    
    static var share = ImageAssetsManager()
    
    var library: PHPhotoLibrary!
    var assets = [PHAsset]()
    var images = [UIImage]()
    
    fileprivate override init() {
        
        super.init()
        library = PHPhotoLibrary.shared()
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == PHAuthorizationStatus.authorized {
                
                let  fetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
                fetchResult.enumerateObjects({ (assetCollection, index, stop) in
                    
                    let assetFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
                    assetFetchResult.enumerateObjects({ (asset, index, stop) in
                        
                        self.assets.append(asset)
                    })
                })
            }
            let imageRequestOption = PHImageRequestOptions()
            imageRequestOption.deliveryMode = .highQualityFormat
            for item in self.assets {
                
                print("\(item.pixelWidth)--\(item.pixelHeight)")
                PHImageManager.default().requestImage(for: item, targetSize: CGSize.init(width: CGFloat(item.pixelWidth), height: CGFloat(item.pixelHeight)), contentMode: PHImageContentMode.default, options: imageRequestOption, resultHandler: { (image, info) in
                    
                    let newImage = UIImage.init(cgImage: image!.cgImage!, scale: UIScreen.main.scale, orientation: .up)
                    self.images.append(newImage)
                })
            }
        }
    }
}
