//
//  NSTimer+Closure.swift
//  NSTimer+Closure
//
//  Created by luojie on 16/3/29.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import Foundation

extension Timer {
    /**
     Closure based timer
     - parameter timeInterval: timeInterval default value 1 seconds
     - parameter duration: total time
     - parameter repeatClosure: called when timeInterval arrived
     - parameter didFinish: called when count down is finished
     */
    @discardableResult
    static func scheduledTimer(_ timeInterval: TimeInterval = 1, duration: TimeInterval, repeatClosure: @escaping (_ remain: TimeInterval) -> Void, didFinish: (() -> Void)? = nil) -> Timer {
        let controller = Controller(timeInterval: timeInterval, duration: duration, repeatClosure: repeatClosure, didFinish: didFinish)
        let timer = scheduledTimer(timeInterval: timeInterval, target: controller, selector: #selector(Controller.action), userInfo: nil, repeats: true)
        timer.controller = controller
        timer.controller.timer = timer
        return timer
    }
    
    fileprivate var controller: Controller! {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.Controller) as? Controller }
        set { objc_setAssociatedObject(self, &AssociatedKeys.Controller, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    fileprivate class Controller {
        
        weak var timer: Timer!
        fileprivate let timeInterval: TimeInterval
        fileprivate var duration: TimeInterval
        fileprivate let repeatClosure: (_ remain: TimeInterval) -> Void
        fileprivate let didFinish: (() -> Void)?
        
        init(timeInterval: TimeInterval, duration: TimeInterval, repeatClosure: @escaping (_ remain: TimeInterval) -> Void, didFinish: (() -> Void)?) {
            self.timeInterval = timeInterval
            self.duration = duration
            self.repeatClosure = repeatClosure
            self.didFinish = didFinish
        }
        
        @objc func action() {
            duration -= timeInterval
            repeatClosure(duration)
            if duration <= 0 {
                didFinish?()
                timer.invalidate()
            }
        }
        
    }
    
    fileprivate struct AssociatedKeys {
        static var Controller = "Controller"
    }
}

