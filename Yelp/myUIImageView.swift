//
//  myUIImageView.swift
//  Yelp
//
//  Created by Vatyx on 2/6/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class myUIImageView: UIImageView {
    
    var width = UIScreen.mainScreen().bounds.width
    
    override var image: UIImage?{
        didSet {
            if image != nil{
                if image!.size.width < width{
                    print(width)
                    let test = resizeImage(image!, newWidth: width)
                    image = test
                }
            } else {
                print("No Image")
            }
        }
    }
    
    func updateSize(width: CGFloat) {
        if let image = image {
            if image.size.width < width {
                let test = resizeImage(image, newWidth: width)
                self.image = test
            }

        }
    }
}

func resizeImage(image_: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image_.size.width
    let newHeight = image_.size.height * scale
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
    image_.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}