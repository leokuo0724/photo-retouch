//
//  RetouchViewController.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/7.
//

import UIKit

class RetouchViewController: UIViewController {
    
    var editImage: UIImage
    var editImageView: EditImageUIView?
    
    @IBOutlet weak var imageView: UIImageView!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.yellow ]
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
    }
    
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
    
    
}
