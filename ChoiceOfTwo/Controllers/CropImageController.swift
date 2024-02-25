//
//  CropImageController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 25/02/2024.
//

import UIKit

class CropImageController: UIViewController {
    
    private let contentView = UIView()
    private var imageView = UIImageView()
    
    private let maskLayer = CAShapeLayer()
    
    private lazy var radius: CGFloat = min(view.bounds.width, view.bounds.height) * 0.45
    private lazy var center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageView.image = UIImage(named: "CropTest")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.view.addSubview(imageView)
        
        let overlay = UIView(frame: CGRectMake(0, 0,
                                               self.view.bounds.width,
                                               self.view.bounds.height))
        
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
