//
//  EditorView.swift
//  Layer
//
//  Created by ldc on 2017/7/12.
//  Copyright © 2017年 HPRT. All rights reserved.
//

import UIKit

protocol EditorCellDelegate: NSObjectProtocol {
    
    func editorSelect(_ cell: EditorCell) -> Void
    
    func cell(_ cell: EditorCell,_ frame: CGRect,transformChange oldTransform: AffineTransformTuple,_ newTransform: AffineTransformTuple) -> Void
    
    func cellDidChangeFrame(_ cell: EditorCell,_ oldFrame: CGRect,_ newFrame: CGRect,_ transform: AffineTransformTuple) -> Void
    
    func cellRemove(_ cell: EditorCell) -> Void
}

protocol EditorViewDelegate: NSObjectProtocol {
    
    func editorView(_ editorView: EditorView,didSelect cell: EditorCell) -> Void
}

class EditorView: UIImageView {
    
    let extensionEdges: CGFloat = -10
    //默认的undoManager有时会变成nil导致崩溃，原因未知
    var customUndoManager: UndoManager!
    weak var delegate: EditorViewDelegate?
    
    var selectedCell: EditorCell?
    
    init(with frame: CGRect) {
        super.init(frame: frame)
        customUndoManager = UndoManager()
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customUndoManager = UndoManager()
        isUserInteractionEnabled = true
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let contained = bounds.insetBy(dx: extensionEdges, dy: extensionEdges).contains(point)
        return contained
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        resignSelectedCell()
    }
    
    func resignSelectedCell() -> Void {
        
        if let tempCell = selectedCell {
            tempCell.isSelected = false
            selectedCell = nil
        }
    }
    
    func selectCell(cell: EditorCell) -> Void {
        
        cell.isSelected = true
        editorSelect(cell)
    }
    
    deinit {
        print("画布没有内存泄漏")
    }
}
//MARK: --UndoManager
extension EditorView {
    
    func addCell(_ cell: EditorCell) -> Void {
        
        cell.delegate = self
        self.addSubview(cell)
        (self.customUndoManager.prepare(withInvocationTarget: self) as AnyObject).removeCell(cell)
    }
    
    func removeCell(_ cell: EditorCell) -> Void {
        
        cell.delegate = nil
        cell.removeFromSuperview()
        (self.customUndoManager.prepare(withInvocationTarget: self) as AnyObject).addCell(cell)
    }
    
    func changeCell(_ cell: EditorCell,_ frame: CGRect,transformChange oldTransform: AffineTransformTuple,_ newTransform: AffineTransformTuple) -> Void {
        
        cell.transform = newTransform.concatenatingTransform()
        cell.affineTransformTuple = newTransform
        (customUndoManager.prepare(withInvocationTarget: self) as AnyObject).changeCell(cell, frame, transformChange: newTransform, oldTransform)
    }
    
    func changeCellFrame(_ cell: EditorCell, _ oldFrame: CGRect, _ newFrame: CGRect, _ transform: AffineTransformTuple) -> Void {
        
        cell.transform = CGAffineTransform.identity
        cell.frame = newFrame
        cell.transform = transform.concatenatingTransform()
        cell.affineTransformTuple = transform
        cell.constFrame = newFrame
        cell.setNeedsDisplay()
        (customUndoManager.prepare(withInvocationTarget: self) as AnyObject).changeCellFrame(cell, newFrame, oldFrame, transform)
    }
    
    func setBackImage(_ image: UIImage?) -> Void {
        
        let lastImage   = self.image
        self.image      = image
        (customUndoManager.prepare(withInvocationTarget: self) as AnyObject).setBackImage(lastImage)
    }
    
    func removeUndoManagerAction() -> Void {
        //MARK: 使用默认的undoManager记录变化时，在EditorView释放前需要移除所有的action，如果没有调用这个方法，将会导致内存泄漏
        undoManager?.removeAllActions(withTarget: self)
    }
    
    func undo() -> Void {
        if customUndoManager.canUndo {
            customUndoManager.undo()
        }
    }
    
    func redo() -> Void {
        if customUndoManager.canRedo {
            customUndoManager.redo()
        }
    }
}

extension EditorView {
    
    func bringSelectedCellToFront() -> Void {
        
        if let temp = selectedCell {
            if let index = subviews.index(of: temp) {
                if index != subviews.count {
                    insertSubview(temp, at: index + 1)
                }
            }
        }
    }
    
    func sendSelectedCellToBack() -> Void {
        
        if let temp = selectedCell {
            if let index = subviews.index(of: temp) {
                if index != 0 {
                    insertSubview(temp, at: index - 1)
                }
            }
        }
    }
}

//MARK: --EditorCellDelegate
extension EditorView: EditorCellDelegate {
    
    func editorSelect(_ cell: EditorCell) {
        
        if let tempCell = selectedCell {
            tempCell.isSelected = false
        }
        delegate?.editorView(self, didSelect: cell)
        selectedCell = cell
    }
    
    func cell(_ cell: EditorCell,_ frame: CGRect,transformChange oldTransform: AffineTransformTuple,_ newTransform: AffineTransformTuple) -> Void {
        
        changeCell(cell, frame, transformChange: oldTransform, newTransform)
    }
    
    func cellRemove(_ cell: EditorCell) {
        
        removeCell(cell)
    }
    
    func cellDidChangeFrame(_ cell: EditorCell, _ oldFrame: CGRect, _ newFrame: CGRect, _ transform: AffineTransformTuple) {
        
        changeCellFrame(cell, oldFrame, newFrame, transform)
    }
}
