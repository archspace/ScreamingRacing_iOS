//
//  DimmingLayerPresentationController.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/20.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit

class DimmingLayerPresentationController: UIPresentationController {
    let dimmingColor:UIColor
    let dimmingView = UIView()
    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, dimmingColor:UIColor) {
        self.dimmingColor = dimmingColor
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    @objc func tapHandler(recognizer:UITapGestureRecognizer){
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        dimmingView.frame = containerView!.bounds
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1
            return
        }
        
        coordinator.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 1
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0
            return
        }
        coordinator.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 0
        }, completion: nil)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        dimmingView.frame = containerView!.bounds
    }
}

private extension DimmingLayerPresentationController {
    
    func setupDimmingView() {
        dimmingView.backgroundColor = dimmingColor
        dimmingView.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler(recognizer:)))
        dimmingView.addGestureRecognizer(tap)
    }
}
