//
//  ViewController.swift
//  Example
//
//  Created by luojie on 16/4/1.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import BNBannerScrollView
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var bannerScrollView: BNBannerScrollView!
    
    var courses: [Course]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courses = [
            Course(id: 0, name: "扬琴艺术", photo: photo1),
            Course(id: 1, name: "演奏技巧", photo: photo2)
        ]

        let banners: [BNBannerScrollView.Banner] = courses.map { course in
            (configureButton: { button in
                button.sd_setBackgroundImage(with: course.photo, for: .normal, placeholderImage: nil)
            },
             configureLabel: { label in
                label.text = course.name
            },
             didSelectBanner: {
                print("pushCourseViewController with id: \(course.id)")
            })
        }
        
        bannerScrollView.banners = banners
    }
    
}

