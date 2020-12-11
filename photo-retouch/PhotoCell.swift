//
//  PhotoCell.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/8.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Notify clear select
        NotificationCenter.default.post(name: NSNotification.Name("clearSelected"), object: nil)
        isSelected(true)
        selectedCell = self
        // Notify set select feature view
        NotificationCenter.default.post(name: NSNotification.Name("setSelectedFeatureView"), object: nil)
    }
    
    func isSelected(_ bool: Bool) {
        if bool {
            self.layer.borderWidth = 3
            self.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        } else {
            self.layer.borderWidth = 0
        }
    }
}
