//
//  SwipeableView.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 19/03/2024.
//

import Foundation
import UIKit


class SwipeableView: UIView {
    
    var delegate: SwipeableViewDelegate?
    
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    private var panGestureTranslation: CGPoint = .zero
    
    private var tapGestureRecognizer: UIGestureRecognizer?
    
    static var maximumRotation: CGFloat = 1.0
    
    static var rotationAngle: CGFloat = CGFloat(Double.pi) / 10.0
    
    static var animationDirectionY: CGFloat = 1.0
    
    static var swipePercentageMargin: CGFloat = 0.6
    
    static var finalizeSwipeActionAnimationDuration: TimeInterval = 0.8
    
    static var cardViewResetAnimationSpringBounciness: CGFloat = 10.0
    
    static var cardViewResetAnimationSpringSpeed: CGFloat = 20.0
    
    static var cardViewResetAnimationDuration: TimeInterval = 0.2
    
    
    init() {
        super.init(frame: .zero)
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupGestureRecognizers() {
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized))
        self.panGestureRecognizer = panGestureRecognizer
        addGestureRecognizer(panGestureRecognizer)

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(_:)))
        self.tapGestureRecognizer = tapGestureRecognizer
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func /*handlePanGesture*/ panGestureRecognized(sender: UIPanGestureRecognizer){
           let card = sender.view as! SwipeableCardViewCard
           let point = sender.translation(in: self)
           let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
           card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
          switch sender.state {
           case .ended:
               if (card.center.x) > 400 {
//                   delegate?.swipeDidEnd(on: card)
                   delegate?.didEndSwipe(onView: self)
                   UIView.animate(withDuration: 0.2) {
                       card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                       card.alpha = 0
                       self.layoutIfNeeded()
                   }
                   return
               }else if card.center.x < -65 {
                   delegate?.didEndSwipe(onView: self)
//                   delegate?.swipeDidEnd(on: card)
                   UIView.animate(withDuration: 0.2) {
                       card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                       card.alpha = 0
                       self.layoutIfNeeded()
                   }
                   return
               }
               UIView.animate(withDuration: 0.2) {
                   card.transform = .identity
                   card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                   self.layoutIfNeeded()
               }
           case .changed:
//                let rotation = tan(point.x / (self.frame.width \ * 2.0))
              let rotation = tan(point.x / (self.frame.width * 2.0))
               card.transform = CGAffineTransform(rotationAngle: rotation)
           default:
               break
           }
       }
    
//    @objc private func panGestureRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
//           panGestureTranslation = gestureRecognizer.translation(in: self)
//
//           switch gestureRecognizer.state {
//           case .began:
//               let initialTouchPoint = gestureRecognizer.location(in: self)
//               let newAnchorPoint = CGPoint(x: initialTouchPoint.x / bounds.width, y: initialTouchPoint.y / bounds.height)
//               let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
//               let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
//               layer.anchorPoint = newAnchorPoint
//               layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)
//
////               removeAnimations()
//               layer.rasterizationScale = UIScreen.main.scale
//               layer.shouldRasterize = true
//               delegate?.didBeginSwipe(onView: self)
//           case .changed:
//               let rotationStrength = min(panGestureTranslation.x / frame.width, SwipeableView.maximumRotation)
//               let rotationAngle = SwipeableView.animationDirectionY * SwipeableView.rotationAngle * rotationStrength
//
//               var transform = CATransform3DIdentity
//               transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
//               transform = CATransform3DTranslate(transform, panGestureTranslation.x, panGestureTranslation.y, 0)
//               layer.transform = transform
//           case .ended:
////               endedPanAnimation()
//               layer.shouldRasterize = false
//           default:
////               resetCardViewPosition()
//               layer.shouldRasterize = false
//           }
//       }
    
    private var dragDirection: SwipeDirection? {
        let normalizedDragPoint = panGestureTranslation.normalizedDistanceForSize(bounds.size)
        return SwipeDirection.allDirections.reduce((distance: CGFloat.infinity, direction: nil), { closest, direction -> (CGFloat, SwipeDirection?) in
            let distance = direction.point.distanceTo(normalizedDragPoint)
            if distance < closest.distance {
                return (distance, direction)
            }
            return closest
        }).direction
    }
    
    private var dragPercentage: CGFloat {
        guard let dragDirection = dragDirection else { return 0.0 }
        
        let normalizedDragPoint = panGestureTranslation.normalizedDistanceForSize(frame.size)
        let swipePoint = normalizedDragPoint.scalarProjectionPointWith(dragDirection.point)
        
        let rect = SwipeDirection.boundsRect
        
        if !rect.contains(swipePoint) {
            return 1.0
        } else {
            let centerDistance = swipePoint.distanceTo(.zero)
            let targetLine = (swipePoint, CGPoint.zero)
            
            return rect.perimeterLines
                .compactMap { CGPoint.intersectionBetweenLines(targetLine, line2: $0) }
                .map { centerDistance / $0.distanceTo(.zero) }
                .min() ?? 0.0
        }
    }
    
//    private func endedPanAnimation() {
//        if let dragDirection = dragDirection, dragPercentage >= SwipeableView.swipePercentageMargin {
//            let translationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
//            translationAnimation?.duration = SwipeableView.finalizeSwipeActionAnimationDuration
//            translationAnimation?.fromValue = NSValue(cgPoint: POPLayerGetTranslationXY(layer))
//            translationAnimation?.toValue = NSValue(cgPoint: animationPointForDirection(dragDirection))
//            layer.pop_add(translationAnimation, forKey: "swipeTranslationAnimation")
//            self.delegate?.didEndSwipe(onView: self)
//        } else {
//            resetCardViewPosition()
//        }
//    }
    
    
    
    private func animationPointForDirection(_ direction: SwipeDirection) -> CGPoint {
          let point = direction.point
          let animatePoint = CGPoint(x: point.x * 4, y: point.y * 4)
          let retPoint = animatePoint.screenPointForSize(UIScreen.main.bounds.size)
          return retPoint
      }
    
//    private func resetCardViewPosition() {
//        removeAnimations()
//
//        // Reset Translation
//        let resetPositionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
//        resetPositionAnimation?.fromValue = NSValue(cgPoint:POPLayerGetTranslationXY(layer))
//        resetPositionAnimation?.toValue = NSValue(cgPoint: CGPoint.zero)
//        resetPositionAnimation?.springBounciness = SwipeableView.cardViewResetAnimationSpringBounciness
//        resetPositionAnimation?.springSpeed = SwipeableView.cardViewResetAnimationSpringSpeed
//        resetPositionAnimation?.completionBlock = { _, _ in
//            self.layer.transform = CATransform3DIdentity
//        }
//        layer.pop_add(resetPositionAnimation, forKey: "resetPositionAnimation")
//
//        // Reset Rotation
//        let resetRotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation)
//        resetRotationAnimation?.fromValue = POPLayerGetRotationZ(layer)
//        resetRotationAnimation?.toValue = CGFloat(0.0)
//        resetRotationAnimation?.duration = SwipeableView.cardViewResetAnimationDuration
//        layer.pop_add(resetRotationAnimation, forKey: "resetRotationAnimation")
//    }

//    private func removeAnimations() {
//        pop_removeAllAnimations()
//        layer.pop_removeAllAnimations()
//    }
    
    
    
    @objc private func tapRecognized(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTap(view: self)
    }
    
}
