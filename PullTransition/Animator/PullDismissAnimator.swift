//
//  PullDismissAnimator.swift
//  PullTransition
//
//  Created by Takuya Ohsawa on 2018/02/18.
//  Copyright © 2018年 Takuya Ohsawa. All rights reserved.
//

import Foundation
import UIKit

final class PullDismissAnimator: NSObject {
    let duration: TimeInterval = 0.6
}

extension PullDismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        
        transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        let screenBounds = UIScreen.main.bounds
        let endFrame = CGRect(x: 0, y: screenBounds.height, width: screenBounds.width, height: screenBounds.height)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        fromVC.view.frame = endFrame
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
