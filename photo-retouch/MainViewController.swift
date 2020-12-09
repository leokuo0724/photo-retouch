//
//  MainViewController.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/7.
//

import UIKit

var imageCollection: Array<UIImage> = []

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewControl: UICollectionView!
    @IBOutlet weak var newButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fullScreenSize = UIScreen.main.bounds.size
        
        // collection view 初始化
        collectionLayout.sectionInset = UIEdgeInsets(top:5, left: 5, bottom: 5, right: 5)
        collectionLayout.itemSize = CGSize(width: fullScreenSize.width/3-10, height: fullScreenSize.width/3-10)
        collectionLayout.minimumLineSpacing = 5
        collectionLayout.scrollDirection = .vertical
        collectionLayout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: 24)
        // button 初始化
        newButton.layer.cornerRadius = newButton.frame.height/2
        newButton.layer.shadowOpacity = 0.4
        newButton.layer.shadowRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionViewControl.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.cellImageView.image = imageCollection[indexPath.row]
        return cell
    }

    // 完成選擇，到次頁編輯
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        if let retouchController = storyboard?.instantiateViewController(identifier: "retouchViewController", creator: { coder in
            RetouchViewController(coder: coder, editImage: image!)
        }) {
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
