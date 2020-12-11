//
//  ResizableView.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/7.
//

import UIKit
import CoreImage

var retouchStatus = RetouchStatus()

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
    let originalImage: UIImage
    var displayImage = UIImage()
    var textField: DraggableTextField?
    
    init?(frame: CGRect, editImage: UIImage) {
        self.originalImage = editImage
        self.displayImage = editImage.copy() as! UIImage
        self.imageInitW = editImage.size.width
        self.imageInitH = editImage.size.height
        super.init(frame: frame)
        
        imageView.image = editImage
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        // 定位
        editInitialize()
        self.addSubview(imageView)
        
        // Notify photo effect
        NotificationCenter.default.addObserver(self, selector: #selector(useFilter), name: NSNotification.Name(rawValue: "useFilter"), object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func editInitialize() {
        // 初始定位
        self.frame = CGRect(x: 0, y: (screenH-screenW)/2, width: screenW, height: screenW)
        imageView.frame.size = CGSize(width: screenW, height: (screenW*imageInitH)/imageInitW)
        imageView.frame.origin = CGPoint(x: (screenW-imageView.frame.width)/2, y: (screenW-imageView.frame.height)/2)
        
        if retouchStatus.isMirrored {
            self.mirror()
        }
        if retouchStatus.rotateCounts % 4 != 0 {
            retouchStatus.rotateCounts = 0
            self.transform = CGAffineTransform(rotationAngle: 0)
        }
        
        // 使用原圖片
        imageView.image = originalImage
        // 色彩平衡歸零
        for prop in retouchStatus.colorControls {
            prop.value = prop.defaultValue
        }
        // 濾鏡歸零
        retouchStatus.effect = nil
        
        // 移除文字
        if let textField = textField {
            retouchStatus.textField = nil
            removeTextField()
        }
        
        // slider 歸位、文字狀態解除
        NotificationCenter.default.post(name: NSNotification.Name("refreshViews"), object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 取消文字編輯
        if let textField = textField {
            textField.endEditing(false)
        }
        // 剪裁
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
            retouchStatus.rotateCounts += 1
        } else {
            retouchStatus.rotateCounts -= 1
        }
        imageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi/180)*90*CGFloat(retouchStatus.rotateCounts))
    }
    func mirror() {
        if !retouchStatus.isMirrored {
            imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        retouchStatus.isMirrored = !retouchStatus.isMirrored
    }
    
    // 色彩平衡
    @objc func useFilter() {
        let status = retouchStatus.colorControls

        let ciImage = CIImage(image: displayImage)
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(status[0].value, forKey: kCIInputBrightnessKey)
        filter?.setValue(status[1].value, forKey: kCIInputContrastKey)
        filter?.setValue(status[2].value, forKey: kCIInputSaturationKey)
        
        // 是否有使用濾鏡
        if let effectName = getEffectKey(effect: retouchStatus.effect) {
            let effectFilter = CIFilter(name: effectName)
            effectFilter?.setValue(filter?.outputImage, forKey: kCIInputImageKey)
            if let outputCIImage = effectFilter?.outputImage {
                let filterImage = UIImage(ciImage: outputCIImage)
                imageView.image = filterImage
            }
        } else {
            if let outputCIImage = filter?.outputImage {
                let filterImage = UIImage(ciImage: outputCIImage)
                imageView.image = filterImage
            }
        }
    }
    
    func createTextField() {
        textField = DraggableTextField(frame: CGRect(x: 0, y: 0, width: 56, height: 34))
        textField?.textAlignment = .center
        textField!.text = "Text"
        textField!.textColor = .black
        textField!.font = UIFont.boldSystemFont(ofSize: 28)
        self.addSubview(textField!)
    }
    
    func removeTextField() {
        textField?.removeFromSuperview()        
    }
    
    func setFontSize(value: Float) {
        guard let textField = textField else {
            return
        }
        textField.font = UIFont.boldSystemFont(ofSize: CGFloat(value))
        textField.textFieldDidChange()
    }
    
    func setFontColor(_ color: UIColor) {
        textField?.textColor = color
    }
    
    // 快照
//    func snapshot() {
//        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
//        let snapshotImage = renderer.image(actions: { (context) in
//            imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
//        })
//        displayImage = snapshotImage
//    }
    
    // 濾鏡效果
//    func colorEffectFilter() {
//        let ciImage = CIImage(image: imageView.image!)
//        let filter = CIFilter(name: "CIPhotoEffectChrome")
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//        if let outputCIImage = filter?.outputImage {
//            let filterImage = UIImage(ciImage: outputCIImage)
//            imageView.image = filterImage
//        }
//    }
}
