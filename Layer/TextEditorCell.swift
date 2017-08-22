//
//  TextEditorCell.swift
//  Layer
//
//  Created by ldc on 2017/7/18.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class TextEditorCell: EditorCell {
    
    override var isSelected: Bool {
        
        didSet {
            
            if isSelected {
                
            }else {
                
                textView.resignFirstResponder()
            }
        }
    }

    var attributeString: NSAttributedString! {
        
        didSet {
            //设置attributedText属性后，textAlignment值会变化
            textView.attributedText = attributeString
            textView.textAlignment  = .center
        }
    }
    
    init(_ frame: CGRect,_ attributeString: NSAttributedString) {
        
        super.init(with: frame)
        self.attributeString = attributeString
        textView.attributedText = attributeString
        textView.textAlignment = NSTextAlignment.center
        textView.updateTextFont()
        whenTapInSelected { [weak self](_) in
            
            self?.textView.becomeFirstResponder()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var textView: UITextView = {
        
        let temp = UITextView.init(frame: self.bounds)
        temp.backgroundColor = UIColor.magenta
        temp.isUserInteractionEnabled = false
        temp.isScrollEnabled = false
        temp.delegate = self
        self.addSubview(temp)
        return temp
    }()
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        textView.resignFirstResponder()
        super.touchesMoved(touches, with: event)
    }
}

extension TextEditorCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.updateTextFont()
    }
}

fileprivate extension UITextView {
    
    /** 自动调整 textView 的font大小 */
    func updateTextFont() {
        if self.text.isEmpty || self.bounds.size.equalTo(.zero) {
            return;
        }
        
        let textViewSize = self.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = self.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT)));
        
        var expectFont = self.font;
        if (expectSize.height > textViewSize.height) {
            
            while (self.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = self.font!.withSize(self.font!.pointSize - 1)
                self.font = expectFont
            }
        }
        else {
            while (self.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = self.font;
                self.font = self.font!.withSize(self.font!.pointSize + 1)
            }
            self.font = expectFont;
        }
    }
}
