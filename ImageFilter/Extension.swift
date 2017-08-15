//
//  extension.swift
//  ImageFilter
//
//  Created by Владимир on 11.08.17.
//  Copyright © 2017 com.favorite. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setLeftMenuButton() {
        let b = UIBarButtonItem(title: "< Back", style: .plain, target: self,
                                action: #selector(click(sender:)))
        
        self.navigationItem.setLeftBarButton(b, animated: true)
    }
    
    func setRightMenuButton() {
        let r = UIBarButtonItem(title: "Save", style: .plain, target: self,
                                action: #selector(saveFilteredImageToGallery(sender:)))
        
        self.navigationItem.setRightBarButtonItems([r], animated: true)
        
        
    }
    
    internal func click(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    internal func saveFilteredImageToGallery(sender: UIBarButtonItem) {
        NotificationManager.postNotification(.saveImage)
    }
    
}

extension UIImage {
    func maskWithColor(color: UIColor, originImage: UIImage) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage:cgImage,
                                       scale:originImage.scale,
                                       orientation:originImage.imageOrientation)
            return coloredImage
        } else {
            return nil
        }
    }
}
