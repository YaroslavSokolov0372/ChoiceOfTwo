//
//  FinalCropImageController.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 28/02/2024.
//

import UIKit

class CropImageController: UIViewController {
    
    //MARK: - Variables
    var vm: CropImageVM!
    
    private var originalImageSize: CGSize = .zero
    private var centrOverlayRelToImage: CGPoint = .zero
    private lazy var radius: CGFloat = min(view.bounds.width, view.bounds.height) * 0.45
    private lazy var rect = CGRectMake(
        CGRectGetMidX(self.view.bounds) - radius,
        CGRectGetMidY(self.view.bounds) - radius,
            2 * radius,
            2 * radius)
    
    //MARK: - UI Components
    private let frontImageView: UIImageView = {
        let imageV = UIImageView()
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
    private let tabBar: UIView = {
        let view = UIView()
        view.backgroundColor = .mainLightGray
        return view
    }()
    private let continueButton: UIButton = CustomCircleButton(customImage: "CheckMark", imageColor: .mainPurple, stroke: true, cornerRadius: 25)
    private let cancelButton: UIButton = CustomCircleButton(customImage: "Plus", rotate: 4, imageColor: .mainPurple, stroke: true, cornerRadius: 25)
    

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        frontImageView.image = vm.image
        view.backgroundColor = .mainDarkGray
        frontImageView.isUserInteractionEnabled = true
        overlay.isUserInteractionEnabled = true
        blurView.isUserInteractionEnabled = true
        overlay.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(wasDragged)))
        frontImageView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(wasZoomed)))
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    

    
    override func viewDidLayoutSubviews() {
        configureFrontImageView()
        setupUI()
        newMask(viewToMask: blurView, rect: rect, invert: true)
        newMask(viewToMask: overlay, rect: rect, invert: true)
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

    public func setFrontImage(image: UIImage) {
        frontImageView.image = image
    }
    
    private func configureFrontImageView() {
        frontImageView.image = vm.image
        frontImageView.frame = CGRectMake(0, 0, view.frame.width, view.frame.height * 0.9)
        print("Original image size", frontImageView.image!.size)
        originalImageSize = frontImageView.image!.size
        view.addSubview(frontImageView)
        setupFrontImageSize(image: frontImageView, rect: rect, center: view.center)
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
        } 
        else if gesture.state == .ended {
            
            let maxY = frontImageView.frame.maxY
            let minY = frontImageView.frame.minY
            let minX = frontImageView.frame.minX
            let maxX = frontImageView.frame.maxX
            let halfOfScreenH = view.frame.height / 2
            let halfOfScreenW = view.frame.width / 2
            let circleMaxY = halfOfScreenH + (rect.width / 2)
            let circleMinY = halfOfScreenH - (rect.width / 2)
            let circleMaxX = halfOfScreenW + (rect.width / 2)
            let circleMinX = halfOfScreenW - (rect.width / 2)
            if circleMaxY > maxY {
                let difference = maxY - circleMaxY
                UIView.animate(withDuration: 0.2) {
//                    print(difference)
//                    print(maxY)
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
    
    @objc private func wasZoomed(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {

            let currentScale = self.frontImageView.frame.size.width / self.frontImageView.bounds.size.width
            let newScale = currentScale * gesture.scale
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.frontImageView.transform = transform
            gesture.scale = 1
        }
    }
    
    @objc private func continueTapped() {
        
        let p = view.convert(view.center, to: frontImageView)
        
        centrOverlayRelToImage = p
        
        var newRect: CGRect = .zero
        let calculateMultiply = originalImageSize.height / frontImageView.frame.height
        let widthMultiply = originalImageSize.width / frontImageView.frame.width
        
                newRect = CGRect(
                    x: widthMultiply * (p.x - radius),
                    y: calculateMultiply * (p.y - radius),
                    width: widthMultiply * rect.width,
                    height: calculateMultiply * rect.height)
        
        let croppedImage = frontImageView.image?.cgImage?.cropping(to: newRect)
        let image = UIImage(cgImage: croppedImage!)

        vm.coordinator.dismiss(image: image)
        self.frontImageView.frame.origin.x = self.view.frame.minX
    }
    
    //MARK: - Side Func
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
        viewToMask.layer.mask = maskLayer
    }
    
    
    @objc private func cancelButtonTapped() {
        vm.coordinator.dismissScreen()
        self.frontImageView.frame.origin.x = self.view.frame.minX
    }
    
    func imageWithImage(image: UIImage, croppedTo rect: CGRect) -> UIImage {

        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        let drawRect = CGRect(x: -rect.origin.x, y: -rect.origin.y,
                              width: image.size.width, height: image.size.height)

        context?.clip(to: CGRect(x: 0, y: 0,
                                 width: rect.size.width, height: rect.size.height))

        image.draw(in: drawRect)

        let subImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return subImage!
    }
    
    func setupFrontImageSize(image: UIImageView, rect: CGRect, center: CGPoint) {
        if rect.height > image.frameForImageInImageViewAspectFit().height {
            let difference = rect.height - image.frameForImageInImageViewAspectFit().height
            
            image.frame = CGRect(x: 0, y: 0, width: image.frameForImageInImageViewAspectFit().width + difference, height: image.frameForImageInImageViewAspectFit().height + difference)
            image.center = center
        }
        if rect.width > image.frameForImageInImageViewAspectFit().width {
            let difference = rect.width - image.frameForImageInImageViewAspectFit().width
            image.frame = CGRect(x: 0, y: 0, width: image.frameForImageInImageViewAspectFit().width + difference, height: image.frameForImageInImageViewAspectFit().height + difference)
            image.center = center
        }
    }
}



