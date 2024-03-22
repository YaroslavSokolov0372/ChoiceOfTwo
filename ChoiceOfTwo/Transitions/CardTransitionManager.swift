//
//  CardTransitionManager.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 22/03/2024.
//

import Foundation
import UIKit


enum CardTranslition {
    case presentation
    case dismissal
}

class CardTransitionManager: NSObject {
    
    public static let shared = CardTransitionManager()
    var transitionDuration: CGFloat = 0.8
    var transition: CardTranslition = .presentation
    let shrinkDuration: Double = 0.2
    var viewControllerRef: UIViewController? = nil
    
    
    
    lazy var blurEffectView : UIVisualEffectView = {
        let blutEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blutEffect)
        return visualEffectView
    }()
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    
    private func addBackgroundViews(to containerView: UIView) {
        
        blurEffectView.frame = containerView.frame
        blurEffectView.alpha = 0.0
        containerView.addSubview(blurEffectView)
        
        dimmingView.frame = containerView.frame
        dimmingView.alpha = 0.0
        containerView.addSubview(dimmingView)
        
        
    }
    
    private func createCardViewCopy(cardView: SwipeCardView)  -> UIImageView {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = cardView.coverImage.image
        imageView.layer.cornerRadius = 30
        return imageView
    }
}

extension CardTransitionManager: UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        
        addBackgroundViews(to: containerView)
        
        let fromView = transitionContext.viewController(forKey: .from)
        let toView = transitionContext.viewController(forKey: .to)
        
        let cardView = (transition == .presentation) ? (viewControllerRef as! CardGameController).selectedCard() :
        (viewControllerRef as! CardGameController).selectedCard()
        
        let cardViewCopy = createCardViewCopy(cardView: cardView)
        containerView.addSubview(cardViewCopy)
        cardView.isHidden = true
        
        let absoluteFrame = cardView.convert(cardView.frame, to: nil)
        cardViewCopy.frame = absoluteFrame
        cardViewCopy.layoutIfNeeded()
        
        whiteView.frame = cardViewCopy.frame
        whiteView.layer.cornerRadius = 30
        containerView.insertSubview(whiteView, belowSubview: cardViewCopy)
        
        if transition == .presentation {
            let detailView = toView as! DetailInfoAnimeController
            containerView.addSubview(detailView.view)
            detailView.viewsAreHidden = true
            
            moveAndConvertToCardView(view: cardViewCopy, containerView: containerView, yOriginToMoveTo: 0) {
                detailView.viewsAreHidden = false
                cardViewCopy.removeFromSuperview()
                cardView.isHidden = false
                transitionContext.completeTransition(true)
            }
        } else {
            
            cardView.isHidden = false
            transitionContext.completeTransition(true)
        }
    }
    
    func makeShrinkAnimator(for view: UIView) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: shrinkDuration, curve: .easeOut) {
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.dimmingView.alpha = 0.05
        }
    }
    
    func makeExpandAnimation(for view: UIView, in conainerView: UIView, yOrigin: CGFloat) -> UIViewPropertyAnimator {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 4))
        let animator = UIViewPropertyAnimator(duration: transitionDuration - shrinkDuration, timingParameters: springTiming)
        
        animator.addAnimations {
            view.transform = .identity
            self.blurEffectView.alpha = 1.0
            
            self.whiteView.layer.cornerRadius = 0
            self.whiteView.frame = conainerView.frame
            
            conainerView.layoutIfNeeded()
        }
        return animator
    }
    
    func moveAndConvertToCardView(view: UIView, containerView: UIView, yOriginToMoveTo: CGFloat, completion: @escaping () -> ()) {
        let shrinkAnimation = makeShrinkAnimator(for: view)
        let expandAnimation = makeExpandAnimation(for: view, in: containerView, yOrigin: yOriginToMoveTo)
        
        shrinkAnimation.addCompletion { _ in
            view.layoutIfNeeded()
            view.setupSizeForDetailInfo()
            expandAnimation.startAnimation()
        }
        expandAnimation.addCompletion { _ in
            completion()
        }
        
        shrinkAnimation.startAnimation()
    }
}

extension CardTransitionManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .presentation
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .dismissal
        return self
    }
}

