//
//  ViewController.swift
//  PullTransition
//
//  Created by Takuya Ohsawa on 2018/02/18.
//  Copyright © 2018年 Takuya Ohsawa. All rights reserved.
//

import UIKit

final class TopViewController: UIViewController {
    private let interactor = Interactor()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func ios9ButtonTapped(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: ModalViewController.self)) as? ModalViewController else {
            return
        }
        vc.interactor = interactor
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .currentContext
        present(vc, animated: true, completion: nil)
    }
}

extension TopViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       return PullDismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactor.hasStarted {
            return interactor
        }else {
            return nil
        }
    }
}
