//
//  DraggableTextField.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/10.
//

import UIKit

class DraggableTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentMode == .textEdit else {
            return
        }
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            let deltaX = currentPoint.x - previous.x
            let deltaY = currentPoint.y - previous.y
            self.frame.origin.x += deltaX
            self.frame.origin.y += deltaY
        }
    }
    
    @objc func textFieldDidChange() {
        let fixedWidth = self.frame.size.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        self.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    
}
