//
//  FinalCropImageController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 28/02/2024.
//

import UIKit

class FinalCropImageController: UIViewController {
    
    //MARK: - Variables
    private lazy var center: CGPoint = self.view.center
    private lazy var radius: CGFloat = min(view.bounds.width, view.bounds.height) * 0.45
    private lazy var rect = CGRectMake(
        CGRectGetMidX(self.frontImageView.bounds) - radius,
        CGRectGetMidY(self.frontImageView.bounds) - radius,
            2 * radius,
            2 * radius)
    
    //MARK: - UI Components
    private let frontImageView: UIImageView = {
        let imageV = UIImageView()
          imageV.contentMode = .scaleAspectFit
          return imageV
    }()
    private let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .light)
        return blurView
    }()
    private lazy var overlay: UIView = {
        let view = UIView()
        view.backgroundColor = .mainLightGray.withAlphaComponent(0.65)
        return view
    }()
    
//    private lazy var overlay = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    
    private let tabBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainLightGray
        return view
    }()
    private let continueButton: UIButton = CustomCircleButton(customImage: "CheckMark", imageColor: .mainPurple, stroke: true)
    private let cancelButton: UIButton = CustomCircleButton(customImage: "Plus", imageColor: .mainPurple, stroke: true)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainDarkGray
        frontImageView.isUserInteractionEnabled = true
        overlay.isUserInteractionEnabled = true
        overlay.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(wasDragged)))
    }
    
    override func viewDidLayoutSubviews() {
        configureFrontImageView()
        setupUI()
        newMask(viewToMask: blurView, rect: rect, invert: true)
        newMask(viewToMask: overlay, rect: rect, invert: true)
        //        configureFrontImageView()
        //        configureOverlay()
        //        configureBlurView()
        //        configureTabBar()
    }
    
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        
        tabBar.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        tabBar.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(overlay)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -60),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 50),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 50),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
        ])
    }
    
    
    private func configureBlurView() {
        
//        blurView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.9)
        
        // Choose the style of the blur effect to regular.
        // You can choose dark, light, or extraLight if you wants
        blurView.effect = UIBlurEffect(style: .light)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
        ])
        
        view.addSubview(blurView)
    }
    
    private func configureOverlay() {
        view.addSubview(overlay)
        overlay.backgroundColor = .mainLightGray
        
        
//        overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
    }
    
    private func configureTabBar() {
        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        tabBar.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        tabBar.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 40),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 40),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func configureFrontImageView() {
        frontImageView.image = UIImage(named: "CropTest")
        frontImageView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height * 0.9)
        view.addSubview(frontImageView)
        frontImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: frontImageView.frameForImageInImageViewAspectFit().size.width,
            height: frontImageView.frameForImageInImageViewAspectFit().size.height
        )
        frontImageView.center = view.center
//        frontImageView.center = view.center
        
        
    }
        
    func newMask(viewToMask: UIView, rect: CGRect, invert: Bool = false) {
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        if invert {
            path.append(UIBezierPath(rect: viewToMask.bounds))
        }
        path.append(UIBezierPath(ovalIn: rect))
        
        maskLayer.path = path.cgPath
        if invert {
            maskLayer.fillRule = .evenOdd
        }
        
//        maskLayer.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor
        viewToMask.layer.mask = maskLayer
    }
    
    //MARK: - Selecrors
    @objc private func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        
        if gesture.state == .began || gesture.state == .changed {
            
            let changeX = (frontImageView.center.x) + translation.x
            let changeY = (frontImageView.center.y) + translation.y
            
            UIView.animate(withDuration: 0.2, delay: 0.5) {
                self.blurView.alpha = 0.0
            }
            
            frontImageView.center = CGPoint(x: changeX, y: changeY)
            gesture.setTranslation(CGPoint.zero, in: frontImageView)
        } else if gesture.state == .ended {
            let maxY = frontImageView.frame.maxY
            let minY = frontImageView.frame.minY
            let minX = frontImageView.frame.minX
            let maxX = frontImageView.frame.maxX
//            let halfOfScreenH = self.view.frame.height / 2
            let halfOfScreenH = frontImageView.frame.height / 2
            let halfOfScreenW = self.view.frame.width / 2
            let circleMaxY = halfOfScreenH + (rect.width / 2)
            let circleMinY = halfOfScreenH - (rect.width / 2)
            let circleMaxX = halfOfScreenW + (rect.width / 2)
            let circleMinX = halfOfScreenW - (rect.width / 2)
            
            if circleMaxY > maxY {

                let difference = maxY - circleMaxY
                UIView.animate(withDuration: 0.2) {
                    self.frontImageView.center = CGPoint(x: self.frontImageView.center.x, y: self.frontImageView.center.y - difference)
                }
            }
            if circleMinY < minY {
                let difference = minY - circleMinY
                UIView.animate(withDuration: 0.2) {
                    self.frontImageView.center = CGPoint(x: self.frontImageView.center.x, y: self.frontImageView.center.y - difference)
                }
            }
            if circleMaxX > maxX {
                let difference = maxX - circleMaxX
                UIView.animate(withDuration: 0.2) {
                    self.frontImageView.center = CGPoint(x: self.frontImageView.center.x - difference, y: self.frontImageView.center.y)
                }
            }
            if circleMinX < minX {
                let difference = minX - circleMinX
                UIView.animate(withDuration: 0.2) {
                    self.frontImageView.center = CGPoint(x: self.frontImageView.center.x - difference, y: self.frontImageView.center.y)
                }
            }
            
            UIView.animate(withDuration: 0.2, delay: 1.0) {
                self.blurView.alpha = 1.0
            }
        }
    }
}

//func mask(viewToMask: UIView, maskRect: CGRect, invert: Bool = false) {
//    let maskLayer = CAShapeLayer()
//    let path = CGMutablePath()
//    if (invert) {
//        path.addRect(viewToMask.bounds)
//    }
////    path.append(UIBezierPath(ovalIn: rect))
//    path.addRect(maskRect)
//
//    maskLayer.path = path
//    if (invert) {
//        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
//    }
//
//    // Set the mask of the view.
//    viewToMask.layer.mask = maskLayer;
//}


