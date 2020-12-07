//
//  MainViewController.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/7.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 完成選擇，到次頁編輯
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        if let retouchController = storyboard?.instantiateViewController(identifier: "retouchViewController") as? RetouchViewController {
            retouchController.editImage = image
            show(retouchController, sender: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
}
