//
//  ExampleViewScrollViewController.swift
//  PullToRefresh
//
//  Created by Narek Simonyan on 9/18/19.
//  Copyright © 2019 InnovationApps. All rights reserved.
//

import UIKit
import NSVPullToRefresh

class ExampleScrollViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addPullToRefresh()
        onProgressListener()
    }
    
    func addPullToRefresh() {
        view.addPullToRefresh { [weak self] in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                strongSelf.view.hidePullToRefresh()
            })
        }
    }
    
    func onProgressListener() {
        view.onProgress = { [weak self] progress in
            print(progress)
        }
    }
}

extension ExampleScrollViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ExampleScrollViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Simple text \(indexPath.row)"
        return cell
    }
}
