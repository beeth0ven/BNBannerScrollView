//
//  BNBannerScrollView.swift
//  BNBannerScrollView
//
//  Created by luojie on 16/3/18.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

/**
 BNBannerScrollView wrapped banners with easy to use api.
 Usage：
 You just need to drag BNBannerScrollView from BNBannerScrollView.storyboard.
 Then create a @IBOutlet with it, lastly give minimal configuration.
 ```swift
class ViewController: UIViewController {
    
    @IBOutlet weak var bannerScrollView: BNBannerScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerScrollView.didSelectBanner = { banner in
            let course = banner as! Course
            print("pushCourseViewController with id: \(course.id)")
        }
 
        self.bannerScrollView.banners = [
            Course(id: 0, name: "扬琴艺术", photo: photo1),
            Course(id: 1, name: "演奏技巧", photo: photo2)
        ]
    }
 
}
```
*/

open class BNBannerScrollView: UIView, UIScrollViewDelegate {
    
    // MARK: Public
    public typealias ConfigureButton = (UIButton) -> Void
    public typealias ConfigureLabel = (UILabel) -> Void
    public typealias DidSelectBanner = (() -> Void)?
    public typealias Banner = (configureButton: ConfigureButton, configureLabel: ConfigureLabel, didSelectBanner: DidSelectBanner)
    public var banners = [Banner]() { didSet { reloadData() } }
    

    open  var currentIndex = 0 {
        didSet {
            guard oldValue != currentIndex else { return }
            didSetCurrentIndex?(currentIndex)
        }
    }

    open var didSetCurrentIndex: ((Int) -> Void)?
    
    @IBInspectable
    open var isCycled: Bool = true
    
    @IBInspectable
    open var isAutoPlay: Bool = true

    // MARK: Properties
    
    
    fileprivate var currentBanner: Banner? {
        if banners.isEmpty { return nil }
        let index = currentIndex % banners.count
        return banners[index]
    }
    
    fileprivate var mode: Mode {
        return (isCycled && self.banners.count > 1) ? .cycle : .nomal
    }
    
    fileprivate var realBanners: [Banner] {
        switch mode {
        case .nomal:
            return self.banners
        case .cycle:
            var banners = [self.banners.last!] + self.banners
            banners += [self.banners.first!]
            return banners
        }
    }
    
    fileprivate var realIndex: Int {
        get {
            switch mode {
            case .nomal:
                return currentIndex
            case .cycle:
                return currentIndex + 1
            }
        }
        set {
            switch mode {
            case .nomal:
                currentIndex = newValue
            case .cycle:
                currentIndex = newValue - 1
            }
        }
    }
    
    fileprivate var scrollView: UIScrollView! {
        guard let scrollView = viewWithTag(1) as? UIScrollView else { return nil }
        if scrollView.delegate == nil {
            scrollView.delegate = self
        }
        return scrollView
    }
    
    fileprivate var contentView: UIView! {
        return viewWithTag(5)
    }
    
    fileprivate var bottomMaskView: UIView! {
        return viewWithTag(2)
    }
    
    fileprivate var titleLabel: UILabel! {
        return viewWithTag(3) as? UILabel
    }
    
    fileprivate var pageControl: UIPageControl! {
        return viewWithTag(4) as? UIPageControl
    }
    
    fileprivate var contentWidth: CGFloat {
        get { return contentViewWidthConstraint.constant }
        set { contentViewWidthConstraint.constant = newValue }
    }
    
    fileprivate var contentViewWidthConstraint: NSLayoutConstraint! {
        return contentView.constraints.find({ $0.identifier == "width" })
    }
    
    // MARK: Update Size
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        updateBannerFrames()
        updateWithCurrentIndex(currentIndex)
    }
    
    fileprivate func updateBannerFrames() {
        contentWidth = CGFloat(realBanners.count) * bounds.width
        for (index, imageView) in contentView.subviews.enumerated() {
            let origin = CGPoint(x: bounds.width * CGFloat(index), y: 0)
            imageView.frame = CGRect(origin: origin, size: bounds.size)
        }
    }
    
    // MARK: Update UI
    
    fileprivate func reloadData() {
        startTimer()
        reloadImageViews()
        currentIndex = 0
        pageControl.numberOfPages = banners.count
        pageControl.isHidden = banners.count < 2
        realBanners.count < 2 ? bottomMaskView.isHidden = true : ()
        layoutSubviews() // Force Update Size in Cell
    }
    
    fileprivate func reloadImageViews() {
        contentView.subviews.removeFromSuperview()
        for banner in realBanners {
            let button = UIButton(type: .system)
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(buttonTaped(_:)), for: .touchUpInside)
            banner.configureButton(button)
            contentView.addSubview(button)
        }
    }
    
    fileprivate func updateWithCurrentIndex(_ index: Int) {
        currentIndex = index
        pageControl.currentPage = currentIndex
        currentBanner?.configureLabel(titleLabel)
        let offset = CGPoint(x: CGFloat(realIndex) * bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: false)
    }
    
    // MARK: IBAction
    
    fileprivate var timer: Timer!
    
    fileprivate func startTimer() {
        guard isAutoPlay else { return }
        if timer == nil {
            timer = Timer.scheduledTimer(5,
                            duration: Double.infinity,
                            repeatClosure: { [weak self] _ in self?.nextPage() })
        }
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    fileprivate func nextPage() {
        switch mode {
        case .nomal:
            break
        case .cycle:
            let offset = scrollView.contentOffset + CGPoint(x: bounds.width, y: 0)
            scrollView.setContentOffset(offset, animated: true)
            Queue.main.executeAfter(0.32) {
                self.scrollViewDidEndDecelerating(self.scrollView)
            }
        }
    }
    
    func buttonTaped(_ sender: UIButton) {
        guard let currentBanner = currentBanner else { return }
        currentBanner.didSelectBanner?()
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        realIndex = Int(scrollView.contentOffset.x / bounds.width)
        switch currentIndex {
        case banners.endIndex:
            updateWithCurrentIndex(currentIndex - banners.count)
        case -1:
            updateWithCurrentIndex(currentIndex + banners.count)
        default:
            updateWithCurrentIndex(currentIndex)
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    fileprivate enum Mode {
        case nomal, cycle
    }
}




