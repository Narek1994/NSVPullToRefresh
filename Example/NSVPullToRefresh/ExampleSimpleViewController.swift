//
//  ExampleSimpleViewController.swift
//  PullToRefresh
//
//  Created by Narek Simonyan on 9/18/19.
//  Copyright © 2019 InnovationApps. All rights reserved.
//

import UIKit
import NSVPullToRefresh

class ExampleSimpleViewController: UIViewController {

    @IBOutlet var stateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addPullToRefresh()
        onProgressListener()
    }
    
    func addPullToRefresh() {
        view.addPullToRefresh { [weak self] in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.stateLabel.text = "Refreshing"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                strongSelf.view.hidePullToRefresh()
                strongSelf.stateLabel.text = "Refreshed"
            })
        }
    }
    
    func onProgressListener() {
        view.onProgress = { [weak self] progress in
            print(progress)
        }
    }
}
