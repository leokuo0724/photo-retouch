//
//  RetouchViewController.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/7.
//

import UIKit

enum Mode {
    case rotateMirror, crop, colorControl
}
enum ColorControlMode {
    case brightness, contrast, saturation
}

var currentMode: Mode = .rotateMirror
var currentColorControlMode: ColorControlMode = .brightness

class RetouchViewController: UIViewController {
    
    var editImage: UIImage
    var editImageView: EditImageUIView?
    
    @IBOutlet weak var rotateMirrorBottom: NSLayoutConstraint!
    @IBOutlet weak var colorControlBottom: NSLayoutConstraint!
    @IBOutlet weak var modeStackView: UIStackView!
    @IBOutlet weak var colorControlBtnStackView: UIStackView!
    @IBOutlet weak var colorControlLabel: UILabel!
    @IBOutlet weak var colorControlSlider: UISlider!
    
    
    init?(coder: NSCoder, editImage: UIImage) {
        self.editImage = editImage
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        editImageView = EditImageUIView(frame: CGRect(x: 0, y: (screenH-screenW)/2, width: screenW, height: screenW), editImage: editImage)!
        view.addSubview(editImageView!)
        
        currentMode = .rotateMirror
        viewsInitSetting()
        setModeIcon()
        
        editImageView?.photoFilter(value: 0.3)
    }
    func viewsInitSetting() {
//        rotateMirrorBottom.constant = -56
    }
    func setModeIcon() {
        // icon 淡色
        modeStackView.subviews.forEach {
            ($0 as! UIButton).alpha = 0.3
        }
        // 收回次功能
        setSubFeatureView(tragetConstraint: rotateMirrorBottom, value: -56)
        setSubFeatureView(tragetConstraint: colorControlBottom, value: -140)
        
        if currentMode == .rotateMirror {
            setIconActive(stackView: modeStackView, index: 0)
            setSubFeatureView(tragetConstraint: rotateMirrorBottom, value: 0)
        } else if currentMode == .crop {
            setIconActive(stackView: modeStackView, index: 1)
        } else if currentMode == .colorControl {
            setIconActive(stackView: modeStackView, index: 2)
            setSubFeatureView(tragetConstraint: colorControlBottom, value: 0)
            setColorControlSubIcon()
        }
    }
    func setColorControlSubIcon() {
        // icon 淡色
        colorControlBtnStackView.subviews.forEach {
            ($0 as! UIButton).alpha = 0.3
        }
        if currentColorControlMode == .brightness {
            setIconActive(stackView: colorControlBtnStackView, index: 0)
            colorControlLabel.text = "Brightness"
            // 當前數值給 slider
        } else if currentColorControlMode == .contrast {
            setIconActive(stackView: colorControlBtnStackView, index: 1)
            colorControlLabel.text = "Contrast"
        } else if currentColorControlMode == .saturation {
            setIconActive(stackView: colorControlBtnStackView, index: 2)
            colorControlLabel.text = "Saturation"
        }
    }
    // 顯示主功能 active
    func setIconActive(stackView: UIStackView, index: Int) {
        let icon = stackView.subviews.first(where: {
            $0.tag == index
        })
        icon?.alpha = 1
    }
    // 顯示次功能面板
    func setSubFeatureView(tragetConstraint: NSLayoutConstraint, value: CGFloat) {
        tragetConstraint.constant = value
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.yellow ]
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
    }
    
    // 圖片儲存/重設
    @IBAction func saveImage(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: editImageView!.bounds.size)
        let image = renderer.image(actions: { (context) in
            editImageView!.drawHierarchy(in: editImageView!.bounds, afterScreenUpdates: true)
        })
        imageCollection.append(image)
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func reset(_ sender: Any) {
        editImageView?.editInitialize()
    }
    
    // 圖片旋轉
    @IBAction func rotateRight(_ sender: Any) {
        editImageView?.rotate(isPositiveDegree: true)
    }
    @IBAction func rotateLeft(_ sender: Any) {
        editImageView?.rotate(isPositiveDegree: false)
    }
    // 圖片鏡射
    @IBAction func mirror(_ sender: Any) {
        editImageView?.mirror()
    }
    
    // 圖片旋轉鏡射模式
    @IBAction func setRotateMirrorMode(_ sender: Any) {
        guard currentMode != .rotateMirror else {
            return
        }
        currentMode = .rotateMirror
        setModeIcon()
    }
    // 圖片剪裁模式
    @IBAction func setCropMode(_ sender: Any) {
        guard currentMode != .crop else {
            return
        }
        currentMode = .crop
        setModeIcon()
    }
    // 色彩調整模式
    @IBAction func setColorControlMode(_ sender: Any) {
        guard currentMode != .colorControl else {
            return
        }
        currentMode = .colorControl
        setModeIcon()
    }
    // 色彩調整-明度模式
    @IBAction func setBrightnessMode(_ sender: Any) {
        guard currentMode == .colorControl,
              currentColorControlMode != .brightness else {
            return
        }
        currentColorControlMode = .brightness
        setColorControlSubIcon()
    }
    // 色彩調整-對比度模式
    @IBAction func setContrastMode(_ sender: Any) {
        guard currentMode == .colorControl,
              currentColorControlMode != .contrast else {
            return
        }
        currentColorControlMode = .contrast
        setColorControlSubIcon()
    }
    // 色彩調整-飽和度模式
    @IBAction func setSaturationMode(_ sender: Any) {
        guard currentMode == .colorControl,
              currentColorControlMode != .saturation else {
            return
        }
        currentColorControlMode = .saturation
        setColorControlSubIcon()
    }
}
