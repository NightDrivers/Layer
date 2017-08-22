//
//  ImageEditor.swift
//  Layer
//
//  Created by ldc on 2017/7/17.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class ImageEditorCell: EditorCell {
    
    var image: UIImage! {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    init(_ frame: CGRect,_ image: UIImage) {
        
        super.init(with: frame)
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        image.draw(in: rect)
    }

}
