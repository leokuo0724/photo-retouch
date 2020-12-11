//
//  RetouchViewController.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/7.
//

import UIKit

enum Mode {
    case rotateMirror, crop, colorControl, photoEffect, textEdit
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
    @IBOutlet weak var textFieldBottom: NSLayoutConstraint!
    
    @IBOutlet weak var modeStackView: UIStackView!
    @IBOutlet weak var colorControlBtnStackView: UIStackView!
    @IBOutlet weak var colorControlLabel: UILabel!
    @IBOutlet weak var colorControlSlider: UISlider!
    @IBOutlet weak var effectScrollContentView: UIView!
    @IBOutlet weak var effectScrollView: UIScrollView!
    
    @IBOutlet weak var textColorWhiteBtn: UIButton!
    @IBOutlet weak var textColorBlackBtn: UIButton!
    @IBOutlet weak var addTextBtn: UIButton!
    @IBOutlet weak var removeTextBtn: UIButton!
    @IBOutlet weak var textSizeSlider: UISlider!
    
    
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
        setModeIcon()
        
        // set photo effect scroll view
        let defaultEffectView = PhotoEffectUIView(frame: CGRect(x: 12, y: 12, width: 114, height: 82), effectType: nil)
        effectScrollContentView.addSubview(defaultEffectView)
        for (index, type) in PhotoEffect.allCases.enumerated() {
            let beginnerX = 12
            let frame = CGRect(x: beginnerX+(index+1)*126, y: 12, width: 114, height: 82)
            let effectUIView = PhotoEffectUIView(frame: frame, effectType: type)
            effectScrollContentView.addSubview(effectUIView)
        }
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(setColorControlSub), name: NSNotification.Name(rawValue: "setColorControlSub"), object: nil)
    }
    func setModeIcon() {
        // icon 淡色
        modeStackView.subviews.forEach {
            ($0 as! UIButton).alpha = 0.3
        }
        // 收回次功能
        setSubFeatureViewConstraint(tragetConstraint: rotateMirrorBottom, value: -56)
        setSubFeatureViewConstraint(tragetConstraint: colorControlBottom, value: -140)
        setSubFeatureViewOrigin(targetView: effectScrollView, value: 800)
        setSubFeatureViewConstraint(tragetConstraint: textFieldBottom, value: -104)
        
        if currentMode == .rotateMirror {
            setIconActive(stackView: modeStackView, index: 0)
            setSubFeatureViewConstraint(tragetConstraint: rotateMirrorBottom, value: 0)
        } else if currentMode == .crop {
            setIconActive(stackView: modeStackView, index: 1)
        } else if currentMode == .colorControl {
            setIconActive(stackView: modeStackView, index: 2)
            setSubFeatureViewConstraint(tragetConstraint: colorControlBottom, value: 0)
            setColorControlSub()
        } else if currentMode == .photoEffect {
            setIconActive(stackView: modeStackView, index: 3)
            setSubFeatureViewOrigin(targetView: effectScrollView, value: 694)
        } else if currentMode == .textEdit {
            setIconActive(stackView: modeStackView, index: 4)
            setSubFeatureViewConstraint(tragetConstraint: textFieldBottom, value: 0)
            setTextEditSub()
        }
    }
    @objc func setColorControlSub() {
        let status = retouchStatus.colorControls
        // icon 淡色
        colorControlBtnStackView.subviews.forEach {
            ($0 as! UIButton).alpha = 0.3
        }
        if currentColorControlMode == .brightness {
            setIconActive(stackView: colorControlBtnStackView, index: 0)
            colorControlLabel.text = "Brightness"
            // slider default:0 min:-1 max:1
            colorControlSlider.minimumValue = -0.5
            colorControlSlider.maximumValue = 0.5
            colorControlSlider.setValue(status[0].value, animated: true)
        } else if currentColorControlMode == .contrast {
            setIconActive(stackView: colorControlBtnStackView, index: 1)
            colorControlLabel.text = "Contrast"
            // slider default:1 min:0 max:5
            colorControlSlider.minimumValue = 0
            colorControlSlider.maximumValue = 2
            colorControlSlider.setValue(status[1].value, animated: true)
        } else if currentColorControlMode == .saturation {
            setIconActive(stackView: colorControlBtnStackView, index: 2)
            colorControlLabel.text = "Saturation"
            // slider default:1 min:0 max:5
            colorControlSlider.minimumValue = 0
            colorControlSlider.maximumValue = 2
            colorControlSlider.setValue(status[2].value, animated: true)
        }
    }
    func setTextEditSub() {
        if let textFieldStatus = retouchStatus.textField {
            textColorWhiteBtn.isEnabled = true
            textColorBlackBtn.isEnabled = true
            addTextBtn.isEnabled = false
            removeTextBtn.isEnabled = true
            textSizeSlider.isEnabled = true
            textSizeSlider.setValue(textFieldStatus.fontSize, animated: true)
        } else {
            textColorWhiteBtn.isEnabled = false
            textColorBlackBtn.isEnabled = false
            addTextBtn.isEnabled = true
            removeTextBtn.isEnabled = false
            textSizeSlider.isEnabled = false
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
    func setSubFeatureViewConstraint(tragetConstraint: NSLayoutConstraint, value: CGFloat) {
        tragetConstraint.constant = value
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    func setSubFeatureViewOrigin(targetView: UIView, value: CGFloat) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            targetView.frame.origin.y = value
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
        setColorControlSub()
    }
    // 色彩調整-對比度模式
    @IBAction func setContrastMode(_ sender: Any) {
        guard currentMode == .colorControl,
              currentColorControlMode != .contrast else {
            return
        }
        currentColorControlMode = .contrast
        setColorControlSub()
    }
    // 色彩調整-飽和度模式
    @IBAction func setSaturationMode(_ sender: Any) {
        guard currentMode == .colorControl,
              currentColorControlMode != .saturation else {
            return
        }
        currentColorControlMode = .saturation
        setColorControlSub()
    }
    // 色彩調整 Slider
    @IBAction func slideColorControl(_ sender: UISlider) {
        guard currentMode == .colorControl else {
            return
        }
        switch currentColorControlMode {
        case .brightness:
            retouchStatus.colorControls[0].value = sender.value
        case .contrast:
            retouchStatus.colorControls[1].value = sender.value
        case .saturation:
            retouchStatus.colorControls[2].value = sender.value
        }
        editImageView?.useFilter()
    }
    @IBAction func setPhotoEffectMode(_ sender: Any) {
        guard currentMode != .photoEffect else {
            return
        }
        currentMode = .photoEffect
        setModeIcon()
    }
    @IBAction func setTextEditMode(_ sender: Any) {
        guard currentMode != .textEdit else {
            return
        }
        currentMode = .textEdit
        setModeIcon()
    }
    @IBAction func addTextField(_ sender: Any) {
        guard retouchStatus.textField == nil else {
            return
        }
        retouchStatus.textField = TextFieldInfo()
        setTextEditSub()
        editImageView!.createTextField()
    }
    @IBAction func removeTextField(_ sender: Any) {
        guard retouchStatus.textField != nil else {
            return
        }
        retouchStatus.textField = nil
        setTextEditSub()
        editImageView!.removeTextField()
    }
    @IBAction func changeFontSize(_ sender: UISlider) {
        guard retouchStatus.textField != nil else {
            return
        }
        editImageView!.setFontSize(value: sender.value)
    }
    @IBAction func setTextColorWhite(_ sender: Any) {
        guard retouchStatus.textField != nil else {
            return
        }
        retouchStatus.textField?.color = .white
        editImageView?.setFontColor(.white)
    }
    @IBAction func setTextColorBlack(_ sender: Any) {
        guard retouchStatus.textField != nil else {
            return
        }
        retouchStatus.textField?.color = .black
        editImageView?.setFontColor(.black)
    }
}
