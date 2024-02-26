//
//  CropImageController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 25/02/2024.
//

import UIKit

class CropImageController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @objc private func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        
        if gesture.state == .began || gesture.state == .changed {
            
            let changeX = (imageView.center.x) + translation.x
            let changeY = (imageView.center.y) + translation.y
            
            imageView.center = CGPoint(x: changeX, y: changeY)
            gesture.setTranslation(CGPoint.zero, in: imageView)
        } else if gesture.state == .ended {
            let maxY = imageView.frame.maxY
            let minY = imageView.frame.minY
            let minX = imageView.frame.minX
            let maxX = imageView.frame.maxX
            let halfOfScreenH = self.view.frame.height / 2
            let halfOfScreenW = self.view.frame.width / 2
            let circleMaxY = halfOfScreenH + 180
            let circleMinY = halfOfScreenH - 180
            let circleMaxX = halfOfScreenW + 180
            let circleMinX = halfOfScreenW - 180
            
            if circleMaxY > maxY {

                let difference = maxY - circleMaxY
//                print("Difference: -", difference)
                UIView.animate(withDuration: 0.2) {
                    self.imageView.center = CGPoint(x: self.imageView.center.x, y: self.imageView.center.y - difference)
                }
//                print("MaxY: -", maxY)
//                print("Cycrle MaxY: -", circleMaxY)
                
            }
            if circleMinY < minY {
                let difference = minY - circleMinY
//                print("Difference: -", difference)
                UIView.animate(withDuration: 0.2) {
                    self.imageView.center = CGPoint(x: self.imageView.center.x, y: self.imageView.center.y - difference)
                }
//                print("MinY: -", maxY)
//                print("Cycrle MinY: -", circleMaxY)
            }
            if circleMaxX > maxX {
                let difference = maxX - circleMaxX
//                print("Difference: -", difference)
                UIView.animate(withDuration: 0.2) {
                    self.imageView.center = CGPoint(x: self.imageView.center.x - difference, y: self.imageView.center.y)
                }
//                print("MaxX: -", maxX)
//                print("Cycrle MaxX: -", circleMaxX)
            }
            if circleMinX < minX {
                let difference = minX - circleMinX
//                print("Difference: -", difference)
                UIView.animate(withDuration: 0.2) {
                    self.imageView.center = CGPoint(x: self.imageView.center.x - difference, y: self.imageView.center.y)
                }
//                print("MaxX: -", minX)
//                print("Cycrle MaxX: -", circleMinX)
            }
        }
    }
    
    @objc private func wasZoomed(gesture: UIPinchGestureRecognizer) {
        print(gesture.velocity)
//        if gesture.state == .began || gesture.state == .changed {
//            
//            var scale = gesture.scale
//            
//            if imageView.image!.scale < scale {
//                let defaultScale: CGFloat = 1
//                let difference = scale - defaultScale
////                scale = 0.8 * scale
//                imageView.transform = imageView.transform.scaledBy(x: defaultScale + (difference * 0.3), y: defaultScale + (difference * 0.3))
//                print("Scaling")
//            }
////                else if imageView.image!.scale < scale {
////                imageView.frame = CGRect(x: 0, y: 0, width: imageView.frame.width * scale, height: imageView.frame.height * scale)
////                imageView.center = view.center
////            }
//            
//            
//
//
//        } else if gesture.state == .ended {
            
//        }
    }
    
    
    private let contentView = UIView()
    private var imageView = UIImageView()
    
    
    private let maskLayer = CAShapeLayer()
    
    private lazy var radius: CGFloat = min(view.bounds.width, view.bounds.height) * 0.45
    private lazy var center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    let overlay = UIView()
    
    private let pathLayer: CAShapeLayer = {
        let pathLayer = CAShapeLayer()
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.black.cgColor
        pathLayer.lineWidth = 3
        return pathLayer
    }()
        
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        imageView.isUserInteractionEnabled = true
        overlay.isUserInteractionEnabled = true
        overlay.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(wasDragged)))
        overlay.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(wasZoomed)))
    }
     
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageView.image = UIImage(named: "CropTest")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        self.view.addSubview(imageView)
        imageView.frame = CGRect(x: 9, y: 0, width: imageView.frameForImageInImageViewAspectFit().size.width, height: imageView.frameForImageInImageViewAspectFit().size.height)
        imageView.center = self.view.center
        
//        let overlay = UIView(frame: CGRectMake(0, 0,
//                                               self.view.bounds.width,
//                                               self.view.bounds.height))
        
        overlay.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        
        overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        

        // Create the initial layer from the view bounds.
        let maskLayer = CAShapeLayer()
        maskLayer.frame = overlay.bounds
        maskLayer.fillColor = UIColor.black.cgColor

        // Create the frame for the circle.
        let radius: CGFloat = 180.0
        let rect = CGRectMake(
                CGRectGetMidX(overlay.frame) - radius,
                CGRectGetMidY(overlay.frame) - radius,
                2 * radius,
                2 * radius)

        // Create the path.
        let path = UIBezierPath(rect: overlay.bounds)
        maskLayer.fillRule = .evenOdd

        // Append the circle to the path so that it is subtracted.
        path.append(UIBezierPath(ovalIn: rect))
        maskLayer.path = path.cgPath

        // Set the mask of the view.
        overlay.layer.mask = maskLayer

        // Add the view so it is visible.
        self.view.addSubview(overlay)
    }
    
    
    func updateCirclePath(at center: CGPoint, radius: CGFloat) {
        self.center = center
        self.radius = radius

        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        maskLayer.path = path.cgPath
        pathLayer.path = path.cgPath
    }
}
