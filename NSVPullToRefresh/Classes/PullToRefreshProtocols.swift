//
//  PullToRefreshProtocols.swift
//  PullToRefresh
//
//  Created by Narek Simonyan on 9/18/19.
//  Copyright © 2019 InnovationApps. All rights reserved.
//

import UIKit

public protocol LoadingView where Self: UIView {
    
    var size: CGSize {get}
    var topOffset: CGFloat {get}
    var speed: CGFloat {get}
    func startLoading()
    func stopLoading()
    
}

extension LoadingView where Self: UIView {
    public var speed: CGFloat {
        return 1
    }
}

protocol GestureReconitionDelegate: class {
    func shouldFailRefreshGesture() -> Bool
}

class PullToRefreshDelegate: NSObject, UIGestureRecognizerDelegate {
    
    private weak var pullGesture: UIPanGestureRecognizer?
    weak var delegate: GestureReconitionDelegate?
    
    init(pullGesture: UIPanGestureRecognizer) {
        self.pullGesture = pullGesture
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pullGesture {
            return delegate?.shouldFailRefreshGesture() ?? false
        }
        return false
    }
}
