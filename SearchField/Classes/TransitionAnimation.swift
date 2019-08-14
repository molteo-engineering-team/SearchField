//
//  TransitionAnimation.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/13/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

/// Fading animation which the SearchViewController uses to animate into the view
public class FadingAnimation: NSObject, UIViewControllerTransitioningDelegate {
    /// duration of 0.5 seconds ot animate into view
    public static var animationDuration: TimeInterval = 0.5
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeOutTransition()
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInTransition()
    }
}

/// Implements the Fading in animation for any controller that would be implementing the following Transition
public class FadeInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return FadingAnimation.animationDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to)!
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        
        toViewController.view.alpha = 0
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.alpha = 0
            toViewController.view.alpha = 1
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

/// Implements the Fading out animation for any controller that would be implementing the following Transition
public class FadeOutTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return FadingAnimation.animationDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to)!
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        
        toViewController.view.alpha = 0
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.alpha = 0
            toViewController.view.alpha = 1
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}
