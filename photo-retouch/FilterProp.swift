//
//  FilterProp.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/10.
//

import Foundation

class FilterProp {
    let type: ColorControlMode
    let defaultValue: Float
    var value: Float
    
    init(type: ColorControlMode,
         defaultValue: Float,
         value: Float) {
        self.type = type
        self.defaultValue = defaultValue
        self.value = value
    }
}
