//
//  PhotoStatus.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/10.
//

import Foundation
import UIKit

class RetouchStatus {
    var isMirrored: Bool = false
    var rotateCounts: Int = 0
    var colorControls: Array<FilterProp> = [
        FilterProp(type: .brightness, value: 0),
        FilterProp(type: .contrast, value: 1),
        FilterProp(type: .saturation, value: 1)
    ]
}

struct FilterProp {
    let type: ColorControlMode
    var value: Float
}
