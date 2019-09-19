//
//  UIView+PullToRefresh.swift
//  PullToRefresh
//
//  Created by Narek Simonyan on 9/18/19.
//  Copyright © 2019 InnovationApps. All rights reserved.
//

import UIKit

public extension UIView {
    
    private var refreshingDelegate: PullToRefreshDelegate? {
        get {
            return getAssociatedValue(key: "refreshingDelegate", object: self, initialValue: nil)
        }
        set {
            set(associatedValue: newValue, key: "refreshingDelegate", object: self)
        }
    }
    
    private var loadingView: LoadingView? {
        get {
            return getAssociatedValue(key: "activityIndicator", object: self, initialValue: nil)
        }
        set {
            set(associatedValue: newValue, key: "activityIndicator", object: self)
        }
    }
    
    private var pullGesture: UIPanGestureRecognizer {
        get {
            return getAssociatedValue(key: "pullGesture", object: self, initialValue: UIPanGestureRecognizer())
        }
        set {
            set(associatedValue: newValue, key: "pullGesture", object: self)
        }
    }
    
    private var topConstraint: NSLayoutConstraint {
        get {
            return getAssociatedValue(key: "topConstraint", object: self, initialValue: NSLayoutConstraint())
        }
        set {
            set(associatedValue: newValue, key: "topConstraint", object: self)
        }
    }
    
    private var scrollViews: [(scrollView: UIScrollView?, initialOffset: CGFloat)] {
        get {
            return getAssociatedValue(key: "scrollViews", object: self, initialValue: [])
        }
        set {
            set(associatedValue: newValue, key: "scrollViews", object: self)
        }
    }
    
    private var onStart: ()->Void {
        get {
            return getAssociatedValue(key: "onStart", object: self, initialValue: {})
        }
        set {
            set(associatedValue: newValue, key: "onStart", object: self)
        }
    }
    
    var onProgress: (_ progress: CGFloat)->Void {
        get {
            return getAssociatedValue(key: "onProgress", object: self, initialValue: {_ in})
        }
        set {
            set(associatedValue: newValue, key: "onProgress", object: self)
        }
    }
    
    func addPullToRefresh(loadingView: LoadingView = UIActivityIndicatorView(style: .gray), onStart: @escaping () -> Void) {
        self.loadingView = loadingView
        addActivityIndicator()
        pullGesture = UIPanGestureRecognizer(target: self, action: #selector(swiped(gesture:)))
        refreshingDelegate = PullToRefreshDelegate(pullGesture: pullGesture)
        refreshingDelegate?.delegate = self
        pullGesture.delegate = refreshingDelegate
        pullGesture.cancelsTouchesInView = false
        self.onStart = onStart
        addGestureRecognizer(pullGesture)
    }
    
    func hidePullToRefresh() {
        DispatchQueue.main.async {
            self.topConstraint.constant = -(self.loadingView?.size.height ?? 60)
            self.pullGesture.isEnabled = true
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
            }, completion: { _ in
                self.loadingView?.stopLoading()
            })
        }
    }
    
    private func addActivityIndicator() {
        guard let loadingView = loadingView else {
            return
        }
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.layer.zPosition = .greatestFiniteMagnitude
        addSubview(loadingView)
        addConstraint(NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        loadingView.addConstraint(NSLayoutConstraint(item: loadingView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: loadingView.size.height))
        loadingView.addConstraint(NSLayoutConstraint(item: loadingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: loadingView.size.height))
        topConstraint = NSLayoutConstraint(item: loadingView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: -loadingView.size.height)
        addConstraint(topConstraint)
        scrollViews = getAllSubviews().map({ (view) -> (scrollView: UIScrollView?, initialOffset: CGFloat) in
            let scrollView = view as? UIScrollView
            return (scrollView: scrollView, initialOffset: scrollView?.contentOffset.y ?? 0)
        })
    }
    
    @objc private func swiped(gesture: UIPanGestureRecognizer) {
        guard let loadingView = loadingView else {
            return
        }
        bringSubviewToFront(loadingView)
        switch gesture.state {
        case .began:
            loadingView.startLoading()
        case .changed:
            if !gesture.direction.isHorizontal && gesture.direction == .topToBottom {
                let translation = gesture.translation(in: self)
                let distance = translation.y
                topConstraint.constant = (distance - loadingView.size.height) * loadingView.speed
                if topConstraint.constant >= loadingView.topOffset {
                    onStart()
                    topConstraint.constant = loadingView.topOffset
                    pullGesture.isEnabled = false
                }
                let initialOffset = loadingView.size.height
                let lastPosition = loadingView.topOffset + initialOffset
                var change = (lastPosition - (topConstraint.constant + initialOffset))/lastPosition
                if change < 0 {
                    change = 0
                } else if change > 1 {
                    change = 1
                }
                onProgress(1 - change)
            }
        case .ended:
            if pullGesture.isEnabled {
                hidePullToRefresh()
            }
        default:
            break
        }
    }
}

extension UIView: GestureReconitionDelegate {
    func shouldFailRefreshGesture() -> Bool {
        return scrollViews.contains(where: { item -> Bool in
            return item.scrollView?.contentOffset.y ?? 0 > item.initialOffset
        })
    }
}
