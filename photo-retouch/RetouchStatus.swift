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
        FilterProp(type: .brightness, defaultValue: 0, value: 0),
        FilterProp(type: .contrast, defaultValue: 1, value: 1),
        FilterProp(type: .saturation, defaultValue: 1, value: 1)
    ]
}
