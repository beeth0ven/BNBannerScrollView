//
//  Course.swift
//  BannerScrollView
//
//  Created by luojie on 16/3/18.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation
import BNBannerScrollView

struct Course {
    var id: Int
    var name: String
    var photo: URL
}

extension Course: BannerType {
    var bannerTitle: String? {
        return name
    }
    
    var bannerPhoto: URL? {
        return photo
    }
    
    var bannerCenterImage: UIImage? {
        return UIImage(named: "play")
    }
}

let photo1 = URL(string: "http://ovfun-10009040.image.myqcloud.com/upload/mavendemo/frontBanner/20151230/1451462965563082313.png")!
let photo2 = URL(string: "http://ovfun-10009040.image.myqcloud.com/upload/mavendemo/frontBanner/20151230/1451462972301417908.jpg")!

