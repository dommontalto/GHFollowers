//
//  Constants.swift
//  GHFollowers
//
//  Created by Dom Montalto on 13/7/2023.
//

import UIKit

enum SFSymbols {
    static let location = UIImage(systemName: "mappin.and.ellipse")
    static let repos = UIImage(systemName: "folder")
    static let gists = UIImage(systemName: "text.alignleft")
    static let followers = UIImage(systemName: "heart")
    static let following = UIImage(systemName: "person.2")
}

enum Images {
    static let placeholder = UIImage(named: "avatar-placeholder")
    static let emptyStateLogo = UIImage(named: "empty-state-logo")
    static let ghLogo = UIImage(named: "gh-logo")
}

enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}


enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale

    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPhone12Mini           = idiom == .phone && ScreenSize.maxLength == 780.0
    static let isiPhone12And12Pro       = idiom == .phone && ScreenSize.maxLength == 844.0
    static let isiPhone12ProMax         = idiom == .phone && ScreenSize.maxLength == 926.0
    static let isiPhone13Mini           = idiom == .phone && ScreenSize.maxLength == 780.0
    static let isiPhone13And13Pro       = idiom == .phone && ScreenSize.maxLength == 844.0
    static let isiPhone13ProMax         = idiom == .phone && ScreenSize.maxLength == 926.0
    static let isiPhone14               = idiom == .phone && ScreenSize.maxLength == 844.0
    static let isiPhone14Plus           = idiom == .phone && ScreenSize.maxLength == 926.0
    static let isiPhone14Pro            = idiom == .phone && ScreenSize.maxLength == 844.0
    static let isiPhone14ProMax         = idiom == .phone && ScreenSize.maxLength == 926.0
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr || isiPhone12Mini || isiPhone12And12Pro || isiPhone12ProMax || isiPhone13Mini || isiPhone13And13Pro || isiPhone13ProMax || isiPhone14 || isiPhone14Plus || isiPhone14Pro || isiPhone14ProMax
    }
}
