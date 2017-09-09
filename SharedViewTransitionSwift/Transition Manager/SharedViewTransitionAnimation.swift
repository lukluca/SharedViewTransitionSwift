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
    let childVC: UIViewController
    let parentVC: UIViewController
    let navigationController: UINavigationController
}

protocol SharedViewTransitionProtocol: class {
    var sharedView: UIView? { get }
}

class SharedViewTransitionAnimation: NSObject {
    
    var transitionParameters: TransitionParameters?
    
    //Define singleton
    static let sharedInstance = SharedViewTransitionAnimation()
    private override init() {}
    
    //MARK: Private methods
    func isTransitionReversed(fromViewController: UIViewController, toViewController: UIViewController) -> Bool {
        
        guard let tranPar = transitionParameters, tranPar.parentVC === toViewController, tranPar.childVC === fromViewController  else {
            return false
        }
        
        return true
    }
    
    //MARK: Public methods
    func addTransitionParameters(fromVCClass: UIViewController, toVCClass: UIViewController, with navigationController: UINavigationController, with duration: TimeInterval) {
        transitionParameters = TransitionParameters(duration: duration, childVC: toVCClass, parentVC: fromVCClass, navigationController: navigationController)
        transitionParameters?.navigationController.delegate = SharedViewTransitionAnimation.sharedInstance
    }
}

extension SharedViewTransitionAnimation: UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else { return }
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            else { return }
        
        let reversed: Bool = isTransitionReversed(fromViewController: fromVC, toViewController: toVC)
        
        guard let fromVCSV = fromVC as? SharedViewTransitionProtocol
            else { return }
        
        guard let toVCSV = toVC  as? SharedViewTransitionProtocol
            else { return }
        
        let fromView = fromVCSV.sharedView
        let toView = toVCSV.sharedView
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        //Take snapshot of fromView
        let snapshot: UIView? = fromView?.snapshotView(afterScreenUpdates: false)
        guard let snapshotView = snapshot else { return }
        if let frame = fromView?.frame {
            snapshotView.frame = containerView.convert(frame, from:fromView?.superview)
        }
        
        fromView?.isHidden = true
        
        //Setup the initial view states
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        
        if (!reversed) {
            toVC.view.alpha = 0
            toView?.isHidden = true
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
            if let frame = toView?.frame {
                snapshotView.frame = containerView.convert(frame, from:toView?.superview)
            }
        }, completion: { (completed) in
            if (completed) {
                //Clean up
                toView?.isHidden = false
                fromView?.isHidden = false
                snapshotView.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        guard let tran = transitionParameters else {
            return 0
        }
        
        return tran.duration
    }
}

extension SharedViewTransitionAnimation: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SharedViewTransitionAnimation.sharedInstance
    }
}
