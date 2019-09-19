//
//  UIActivityIndicatorView+LoadingView.swift
//  PullToRefresh
//
//  Created by Narek Simonyan on 9/18/19.
//  Copyright © 2019 InnovationApps. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView: LoadingView {
    
    public func startLoading() {
        startAnimating()
    }
    
    public func stopLoading() {
        stopAnimating()
    }
    
    public var size: CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    public var topOffset: CGFloat {
        return 60
    }
}
