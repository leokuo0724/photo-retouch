//
//  ResizableView.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/7.
//

import UIKit

class EditImageUIView: UIView {

    enum Edge {
        case topLeft, topRight, bottomLeft, bottomRight, none
    }

    static var edgeSize: CGFloat = 44.0
    private typealias `Self` = EditImageUIView

    let screenW = UIScreen.main.bounds.width
    let screenH = UIScreen.main.bounds.height
    var currentEdge: Edge = .none
    var touchStart = CGPoint.zero
    var imageView = UIImageView()
    
    init?(frame: CGRect, editImage: UIImage) {
        super.init(frame: frame)
        imageView.image = editImage
        
        let imageWidth = editImage.size.width
        let imageHeight = editImage.size.height
        let selfWidth = self.frame.width
        let selfHeight = self.frame.height
        // 定位
        imageView.frame.size = CGSize(width: screenW, height: (screenW*imageHeight)/imageWidth)
        imageView.frame.origin = CGPoint(x: (selfWidth-imageView.frame.width)/2, y: (selfHeight-imageView.frame.height)/2)
        self.backgroundColor = .black
        self.clipsToBounds = true
        self.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {

            touchStart = touch.location(in: self)

            currentEdge = {
                if self.bounds.size.width - touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
                    return .bottomRight
                } else if touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
                    return .topLeft
                } else if self.bounds.size.width-touchStart.x < Self.edgeSize && touchStart.y < Self.edgeSize {
                    return .topRight
                } else if touchStart.x < Self.edgeSize && self.bounds.size.height - touchStart.y < Self.edgeSize {
                    return .bottomLeft
                }
                return .none
            }()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            let previous = touch.previousLocation(in: self)

            let originX = self.frame.origin.x
            let originY = self.frame.origin.y
            let width = self.frame.size.width
            let height = self.frame.size.height

            let deltaWidth = currentPoint.x - previous.x
            let deltaHeight = currentPoint.y - previous.y

            switch currentEdge {
            case .topLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY + deltaHeight, width: width - deltaWidth, height: height - deltaHeight)
                imageView.frame.origin.x -= deltaWidth
                imageView.frame.origin.y -= deltaHeight
            case .topRight:
                self.frame = CGRect(x: originX, y: originY + deltaHeight, width: width + deltaWidth, height: height - deltaHeight)
                imageView.frame.origin.y -= deltaHeight
            case .bottomRight:
                self.frame = CGRect(x: originX, y: originY, width: width + deltaWidth, height: height + deltaWidth)
            case .bottomLeft:
                self.frame = CGRect(x: originX + deltaWidth, y: originY, width: width - deltaWidth, height: height + deltaHeight)
            default:
                break
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentEdge = .none
        self.frame.origin.x = (screenW-self.frame.width)/2
        self.frame.origin.y = (screenH-self.frame.height)/2
    }
}
