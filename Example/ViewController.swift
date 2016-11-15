//
//  ViewController.swift
//  Example
//
//  Created by luojie on 16/4/1.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import BNBannerScrollView


class ViewController: UIViewController {
    
    @IBOutlet weak var bannerScrollView: BNBannerScrollView!
    
    var courses: [Course]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerScrollView.didSelectBanner = { banner in
            let course = banner as! Course
            print("pushCourseViewController with id: \(course.id)")
        }
        
        courses = [
            Course(id: 0, name: "扬琴艺术", photo: photo1),
            Course(id: 1, name: "演奏技巧", photo: photo2)
        ]
        
        bannerScrollView.banners = courses.map { $0 as BannerType }
    }
    
}

