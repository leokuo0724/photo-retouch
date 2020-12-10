//
//  PhotoEffectEnum.swift
//  photo-retouch
//
//  Created by 郭家銘 on 2020/12/10.
//

import Foundation

enum PhotoEffect: CaseIterable {
    case chrome, fade, instant, mono, noir, process, tonal, transfer
}

func getEffectKey(effect: PhotoEffect?) -> String? {
    switch effect {
    case .chrome:
        return "CIPhotoEffectChrome"
    case .fade:
        return "CIPhotoEffectFade"
    case .instant:
        return "CIPhotoEffectInstant"
    case .mono:
        return "CIPhotoEffectMono"
    case .noir:
        return "CIPhotoEffectNoir"
    case .process:
        return "CIPhotoEffectProcess"
    case .tonal:
        return "CIPhotoEffectTonal"
    case .transfer:
        return "CIPhotoEffectTransfer"
    default:
        return nil
    }
}

func getEffectName(effect: PhotoEffect?) -> String {
    switch effect {
    case .chrome:
        return "Chrome"
    case .fade:
        return "Fade"
    case .instant:
        return "Instant"
    case .mono:
        return "Mono"
    case .noir:
        return "Noir"
    case .process:
        return "Process"
    case .tonal:
        return "Tonal"
    case .transfer:
        return "Transfer"
    default:
        return "Default"
    }
}
