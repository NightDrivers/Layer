//
//  EditorController.swift
//  Layer
//
//  Created by ldc on 2017/7/12.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

class EditorController: UIViewController {

    @IBOutlet weak var editorView: EditorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        editorView.removeUndoManagerAction()
    }
    
    @IBAction func addCell(_ sender: UIButton) {
        
        let cell = EditorCell.init(with: CGRect.init(x: 100, y: 200, width: 50, height: 50))
        cell.whenTapInSelected { (cell1) in
            cell1.isSelected = !cell1.isSelected
        }
        editorView.addCell(cell)
    }
    @IBAction func undo(_ sender: UIButton) {
        editorView.undo()
    }

    @IBAction func redo(_ sender: UIButton) {
        editorView.redo()
    }
    
    @IBAction func addImageCell(_ sender: UIButton) {
        
        let imageCell = ImageEditorCell.init(CGRect.init(x: 100, y: 200, width: 180, height: 80), UIImage.init(named: "2")!)
        editorView.addCell(imageCell)
    }
    
    @IBAction func addTextCell(_ sender: UIButton) {
        
        let textCell = TextEditorCell.init(CGRect.init(x: 100, y: 200, width: 180, height: 80), NSAttributedString.init(string: "abcd"))
        editorView.addCell(textCell)
    }
    
    deinit {
        print("控制器没有内存泄漏")
    }
}
