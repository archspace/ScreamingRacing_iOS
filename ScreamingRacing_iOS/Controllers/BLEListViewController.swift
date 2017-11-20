//
//  BLEListViewController.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/20.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit

class BLEListViewController: UIViewController {
    
    let gradientLayer = CAGradientLayer()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [AppColor.ListGradientStart!.cgColor, AppColor.ListGradientEnd!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x:0.5, y:1)
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        tableView.frame = view.bounds
    }
    

   

}
