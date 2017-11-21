//
//  DropDownTransitionDelegate.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/20.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit
import PinLayout

class DropDownAnimatedTransitioning:NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting = true
    let duration:TimeInterval
    let topOffset:CGFloat
    var transitionContext: UIViewControllerContextTransitioning?
    
    init(isPresenting:Bool, duration:TimeInterval, topOffset:CGFloat) {
        self.duration = duration
        self.isPresenting = isPresenting
        self.topOffset = topOffset
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        let mask = CAShapeLayer()
        let frame = containerView.bounds
        let h = frame.height - topOffset
        var initPath:UIBezierPath?
        var finalPath:UIBezierPath?
        if isPresenting {
            containerView.addSubview(toVC.view)
            fromVC.view.frame = frame
            toVC.view.frame = CGRect(x: 0, y: topOffset, width: frame.width, height: h )
            
            finalPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: h))
            initPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: 1))
            toVC.view.layer.mask = mask
        }else {
        
            initPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: h))
            finalPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: 1))
            fromVC.view.layer.mask = mask
        }
        mask.path = finalPath!.cgPath
        
        let maskAnimation = CABasicAnimation(keyPath: "path")
        maskAnimation.fromValue = initPath!.cgPath
        maskAnimation.toValue = finalPath!.cgPath
        maskAnimation.duration = duration
        maskAnimation.delegate = self
        mask.add(maskAnimation, forKey: "path")
        
    }
}

extension DropDownAnimatedTransitioning: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if isPresenting {
            transitionContext?.viewController(forKey: .to)?.view.layer.mask = nil
        }else {
            transitionContext?.viewController(forKey: .from)?.view.layer.mask = nil
        }
        transitionContext?.completeTransition(flag)
    }
}

class DropDownTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    let duration:TimeInterval
    let topOffset:CGFloat
    
    init(transitionDuration:TimeInterval, topOffset:CGFloat) {
        duration = transitionDuration
        self.topOffset = topOffset
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingLayerPresentationController(presentedViewController: presented, presentingViewController: presenting, dimmingColor: UIColor.clear)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DropDownAnimatedTransitioning(isPresenting: true, duration: duration, topOffset:topOffset)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DropDownAnimatedTransitioning(isPresenting: false, duration: duration, topOffset:topOffset)
    }
    
}
