//
//  RetouchViewController.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/7.
//

import UIKit

enum Mode {
    case rotateMirror, crop
}
var currentMode: Mode = .rotateMirror

class RetouchViewController: UIViewController {
    
    var editImage: UIImage
    var editImageView: EditImageUIView?
    
    @IBOutlet weak var rotateMirrorBottom: NSLayoutConstraint!
    @IBOutlet weak var modeStackView: UIStackView!
    
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
        
        viewsInitSetting()
        setModeIcon()
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
        setRotateMirrorSub(false)
        
        if currentMode == .rotateMirror {
            let rotateMirrorBtn = modeStackView.subviews.first(where: {
                $0.tag == 0
            })
            rotateMirrorBtn?.alpha = 1
            setRotateMirrorSub(true)
        } else if currentMode == .crop {
            let rotateMirrorBtn = modeStackView.subviews.first(where: {
                $0.tag == 1
            })
            rotateMirrorBtn?.alpha = 1
        }
    }
    // 顯示 rotateMirror 次功能
    func setRotateMirrorSub(_ bool: Bool) {
        if bool {
            rotateMirrorBottom.constant = 0
        } else {
            rotateMirrorBottom.constant = -56
        }
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
}
