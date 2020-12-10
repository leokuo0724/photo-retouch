//
//  PhotoEffectUIView.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/10.
//

import UIKit

class PhotoEffectUIView: UIView {
    
    let effectType: PhotoEffect?

    init(frame: CGRect, effectType: PhotoEffect?) {
        self.effectType = effectType
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        // background image
        let effectName = getEffectName(effect: effectType ?? nil)
        let bgImageView = UIImageView(image: UIImage(named: effectName))
        bgImageView.frame.origin = CGPoint(x: 0, y: 0)
        bgImageView.frame.size = self.frame.size
        bgImageView.alpha = 0.9
        self.addSubview(bgImageView)
        
        // label
        let label = UILabel()
        label.frame.origin = CGPoint(x: 0, y: 0)
        label.frame.size = self.frame.size
        label.text = effectName
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(label)
        
        // set interactive
        let gesture = UITapGestureRecognizer(target: self, action: #selector(setPhotoEffect))
        self.addGestureRecognizer(gesture)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setPhotoEffect() {
        retouchStatus.effect = effectType
        NotificationCenter.default.post(name: NSNotification.Name("useFilter"), object: nil)
    }
    
}
