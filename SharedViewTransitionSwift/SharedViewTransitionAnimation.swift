//
//  SharedViewTransitionAnimation.swift
//  SharedViewTransitionSwift
//
//  Created by Pasini, Nicolò on 08/09/2017.
//  Copyright © 2017 Tagliabue, L. All rights reserved.
//

import UIKit

struct TransitionParameters {
    let duration: TimeInterval
    let childVC: ChildViewController
    let parentVC: ParentViewController
    let navigationController: UINavigationController

}

class SharedViewTransitionAnimation {

    let transitionParameters: TransitionParameters
    
    //Define singleton
    static let sharedInstance = SharedViewTransitionAnimation()
    private init() {}
    
//MARK: Private methods
    func isTransitionReversed(fromViewController: UIViewController, toViewController: UIViewController) -> BOOL {
        let parameters: TransitionParameters = transitionParameters
        
        if (parameters.parentVC == oViewController.class, parameters.childVC == tfromViewController.class) {
            return true
        }
    
        return false
    }

//MARK: Public methods
    func addTransitionParameters(fromVCClass: SharedViewTransitionDataSource.Type, toVCClass: SharedViewTransitionDataSource.Type, with navigationController: UINavigationController, with duration: TimeInterval) {
        
        transitionParameters = TransitionParameters(parentVC: fromVCClass, childVC: toVCClass, navigationController: navigationController, duration: duration)
        transitionParameters.navigationController.delegate = sharedInstance
    }
}

extension SharedViewTransitionAnimation: UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC: UIViewController<SharedViewTransitionDataSource> = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVC: UIViewController<SharedViewTransitionDataSource> = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        guard let parameters = transitionParameters else { return }
        
        let reversed: BOOL = isTransitionReversed(fromVC, toVC)
        
        let fromView: UIView = fromVC.sharedView
        let toView: UIView = toVC.sharedView
        
        let containerView: UIView = transitionContext.sharedView
        let duration: TimeInterval = transitionDuration(transitionContext)
        
        //Take snapshot of fromView
        let snapshotView: UIView = fromView.snapshotViewAfterScreenUpdates(false)
        snapshotView.frame = containerView.convertRect(fromView.frame, fromView:fromView.superview)
        fromView.hidden = true
        
        //Setup the initial view states
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        
        if (!reversed) {
            toVC.view.alpha = 0
            toView.hidden = true
            containerView.addSubview(toVC.view)
        } else {
            containerView.insertSubview(toVC.view, belowSubview:fromVC.view)
        }
        
        containerView.addSubview(snapshotView)
        
        UIView.animate(withDuration: duration, animations: {
            if (!reversed) {
                toVC.view.alpha = 1 //Fade in
            } else {
                fromVC.view.alpha = 0 //Fade out
            }
            
            //Move the snapshot
            snapshotView.frame = containerView.convertRect(toView.frame, fromView:toView.superview)
        }, completion: { (completed) in
            if (completed) {
                //Clean up
                toView.hidden = false
                fromView.hidden = false
                snapshotView.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        let toVC: UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVC: UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        if let parameters = transitionParameters {
            return parameters.duration
        } else {
            return 0
        }
    }
}

extension SharedViewTransitionAnimation: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                                       animationControllerFor operation: UINavigationControllerOperation,
                                       from fromVC: UIViewController,
                                       to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let parameters = transitionParameters {
            return sharedInstance
        } else {
            return nil
        }
    }
}

protocol SharedViewTransitionDataSource {
    var sharedView: UIView
}
