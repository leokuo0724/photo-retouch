//
//  MainViewController.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/7.
//

import UIKit

var imageCollection: Array<UIImage> = []
var selectedCell: PhotoCell? = nil

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewControl: UICollectionView!
    @IBOutlet weak var newButton: UIButton!
    
    @IBOutlet weak var newBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var selectedFeatureViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var illustrationView: UIView!
    
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
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(clearSelected), name: NSNotification.Name("clearSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setSelectedFeatureView), name: NSNotification.Name("setSelectedFeatureView"), object: nil)
        
        setSelectedFeatureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionViewControl.reloadData()
        setIllustrationView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.cellImageView.image = imageCollection[indexPath.row]
        return cell
    }
    
    // 沒有cell時插畫呈現
    func setIllustrationView() {
        if imageCollection.count == 0 {
            illustrationView.isHidden = false
        } else {
            illustrationView.isHidden = true
        }
    }
    
    // 清除選取 cell
    @objc func clearSelected() {
        if selectedCell != nil {
            selectedCell!.isSelected(false)
            selectedCell = nil
        }
    }
    @objc func setSelectedFeatureView() {
        if selectedCell != nil {
            selectedFeatureViewBottom.constant = 0
            newBtnBottom.constant = -48
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            selectedFeatureViewBottom.constant = -72
            newBtnBottom.constant = 48
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
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
    
    @IBAction func deletePhoto(_ sender: Any) {
        let index = imageCollection.firstIndex(of: (selectedCell?.cellImageView.image)!)
        imageCollection.remove(at: index!)
        collectionViewControl.reloadData()
        setIllustrationView()
        // 刪除後取消選取
        clearSelected()
        setSelectedFeatureView()
    }
    @IBAction func sharePhoto(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [selectedCell?.cellImageView.image], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.clearSelected()
                self.setSelectedFeatureView()
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelSelect(_ sender: Any) {
        clearSelected()
        setSelectedFeatureView()
    }
    
}
