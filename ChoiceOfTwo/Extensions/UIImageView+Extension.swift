//
//  UIImageView+Extension.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 26/02/2024.
//

import Foundation
import UIKit
import AVFoundation

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
    
    func getScaledImageSize() -> CGRect? {
        if let image = self.image {
            return AVMakeRect(aspectRatio: image.size, insideRect: self.frame);
        }

        return nil;
    }
    
    func frameForImageInImageViewAspectFit() -> CGRect
    {
        if  let img = self.image {
            let imageRatio = img.size.width / img.size.height;
            
            let viewRatio = self.frame.size.width / self.frame.size.height;
            
            if(imageRatio < viewRatio)
            {
                let scale = self.frame.size.height / img.size.height;
                
                let width = scale * img.size.width;
                
                let topLeftX = (self.frame.size.width - width) * 0.5;
                
                return CGRectMake(topLeftX, 0, width, self.frame.size.height);
            }
            else
            {
                let scale = self.frame.size.width / img.size.width;
                
                let height = scale * img.size.height;
                
                let topLeftY = (self.frame.size.height - height) * 0.5;
                
                return CGRectMake(0, topLeftY, self.frame.size.width, height);
            }
        }
        
        return CGRectMake(0, 0, 0, 0)
    }
}
