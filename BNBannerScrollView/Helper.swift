//
//  Helper.swift
//  BannerScrollView
//
//  Created by luojie on 16/3/18.
//  Copyright © 2016年 LuoJie. All rights reserved.
//


import UIKit

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

extension Array where Element: UIView {
    func removeFromSuperview() {
        forEach { $0.removeFromSuperview() }
    }
}

extension Array {
    func find(_ predicate: (Element) -> Bool) -> Element? {
        return filter(predicate).first
    }
}

/**
 提供常用线程的简单访问方法. 用 Qos 代表线程对应的优先级。
 - Main:                 对应主线程
 - UserInteractive:      对应优先级高的线程
 - UserInitiated:        对应优先级中的线程
 - Utility:              对应优先级低的线程
 - Background:           对应后台的线程
 
 例如，异步下载图片可以这样写：
 ```swift
 Queue.UserInitiated.execute {
 
 let url = NSURL(string: "http://image.jpg")!
 let data = NSData(contentsOfURL: url)!
 let image = UIImage(data: data)
 
 Queue.Main.execute {
 imageView.image = image
 }
 }
 */

enum Queue: ExcutableQueue {
    case main
    case userInteractive
    case userInitiated
    case utility
    case background
    
    var queue: DispatchQueue {
        switch self {
        case .main:
            return DispatchQueue.main
        case .userInteractive:
            return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:
            return DispatchQueue.global(qos: .userInitiated)
        case .utility:
            return DispatchQueue.global(qos: .utility)
        case .background:
            return DispatchQueue.global(qos: .background)
        }
    }
}

/// 提供本 App 要使用的所有 SerialQueue，以下的 case 只是一个例子，可以根据需要修改
enum SerialQueue: String, ExcutableQueue {
    
    case DownLoadImage = "ovfun.Education.SerialQueue.DownLoadImage"
    case UpLoadFile = "ovfun.Education.SerialQueue.UpLoadFile"
    
    var queue: DispatchQueue {
        return DispatchQueue(label: rawValue)
    }
}

/// 给 Queue 提供默认的执行能力
protocol ExcutableQueue {
    var queue: DispatchQueue { get }
}

extension ExcutableQueue {
    func execute(_ closure: @escaping () -> Void) {
        queue.async(execute: closure)
    }
    
    func executeAfter(_ seconds: TimeInterval, closure: @escaping () -> Void) {
        let delay = DispatchTime.now() + seconds
        queue.asyncAfter(deadline: delay, execute: closure)
    }
}
