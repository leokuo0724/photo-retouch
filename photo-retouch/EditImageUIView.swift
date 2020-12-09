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

    let screenW = UIScreen.main.bounds.width // 作為初始view長寬
    let screenH = UIScreen.main.bounds.height
    let imageInitW: CGFloat
    let imageInitH: CGFloat
    var currentEdge: Edge = .none
    var touchStart = CGPoint.zero
    var imageView = UIImageView()
    
    var isMirrored: Bool = false
    var rotateCounts: Int = 0
    
    init?(frame: CGRect, editImage: UIImage) {
        self.imageInitW = editImage.size.width
        self.imageInitH = editImage.size.height
        super.init(frame: frame)
        
        imageView.image = editImage
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        // 定位
        editInitialize()
        self.addSubview(imageView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func editInitialize() {
        // 初始定位
        self.frame = CGRect(x: 0, y: (screenH-screenW)/2, width: screenW, height: screenW)
        imageView.frame.size = CGSize(width: screenW, height: (screenW*imageInitH)/imageInitW)
        imageView.frame.origin = CGPoint(x: (screenW-imageView.frame.width)/2, y: (screenW-imageView.frame.height)/2)
        
        if isMirrored {
            self.mirror()
        }
        if rotateCounts % 4 != 0 {
            rotateCounts = 0
            self.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    // 拖拉
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentMode == .crop else {
            return
        }
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
        guard currentMode == .crop else {
            return
        }
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
        guard currentMode == .crop else {
            return
        }
        currentEdge = .none
        if (self.frame.width > UIScreen.main.bounds.width) {
            self.frame.size.width = UIScreen.main.bounds.width
        }
        if (self.frame.height > UIScreen.main.bounds.width) {
            self.frame.size.height = UIScreen.main.bounds.width
        }
        self.frame.origin.x = (screenW-self.frame.width)/2
        self.frame.origin.y = (screenH-self.frame.height)/2
    }
    
    
    func rotate(isPositiveDegree: Bool) {
        if isPositiveDegree {
            self.rotateCounts += 1
        } else {
            self.rotateCounts -= 1
        }
        imageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi/180)*90*CGFloat(self.rotateCounts))
    }
    func mirror() {
        if !isMirrored {
            imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        isMirrored = !isMirrored
    }
}
