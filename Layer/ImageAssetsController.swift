//
//  ImageAssetsController.swift
//  Layer
//
//  Created by ldc on 2017/8/2.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class ImageAssetsController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var flag = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let manager = ImageAssetsManager.share
        
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            if manager.images.count != 0 {
                
                if self.flag > manager.images.count - 1 {
                    self.flag = 0
                }
                self.imageView.image = manager.images[self.flag]
                self.flag += 1
            }
        }
    }

}
