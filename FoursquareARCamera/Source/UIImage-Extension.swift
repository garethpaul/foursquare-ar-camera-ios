//
//  UIImage-Extension.swift
//  FoursquareARCamera
//
//  Created by Gareth Paul Jones on 7/31/17.
//  Copyright © 2017 Foursquare. All rights reserved.
//
import UIKit
import QuartzCore


extension UIImage {
    class func imageWithView(view: FSQView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        ///view.layer.render(in: UIGraphicsGetCurrentContext()!)
        //view.backgroundColor = UIColor.white
        //view.isOpaque = false
        
        
        //view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageData = UIImagePNGRepresentation(img!)
        

        return UIImage(data: imageData!)!
        //return img!
    }
    
    func imageBez(with path: UIBezierPath, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.blue.setStroke()
        path.lineWidth = 2
        path.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func imageByApplyingClippingBezierPath(_ path: UIBezierPath) -> UIImage {
        // Mask image using path
        let maskedImage = imageByApplyingMaskingBezierPath(path)
        
        // Crop image to frame of path
        let croppedImage = UIImage(cgImage: maskedImage.cgImage!.cropping(to: path.bounds)!)
        return croppedImage
    }
    
    func to8BitLayer(color: UIColor = .white) -> CALayer? {
        guard let cgImage = self.cgImage else { return nil }
        let height = Int(self.size.height * scale)
        let width = Int(self.size.width * scale)
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: CGImageAlphaInfo.alphaOnly.rawValue) else {
            print("Couldn't create CGContext")
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let image = context.makeImage() else {
            print("Couldn't create image from context")
            return nil
        }
        
        // Note that self.size corresponds to the non-scaled (retina) dimensions, so is not the same size as the context
        let frame = CGRect(origin: .zero, size: self.size)
        
        let mask = CALayer()
        mask.contents = image
        mask.contentsScale = scale
        mask.frame = frame
        
        let layer = CALayer()
        layer.backgroundColor = color.cgColor
        layer.mask = mask
        layer.contentsScale = scale
        layer.frame = frame
        
        return layer
    }
    
    
    class func maskedImage(_ color: UIColor, withAlphaMask mask: UIImage) -> UIImage {
        //First draw the background color into an image
        //UIGraphicsBeginImageContextWithOptions(mask.size, false, mask.scale)
        //color.setFill()
        //UIRectFill(CGRect(x: 0, y: 0, width: mask.size.width, height: mask.size.height))
        let iconBackground: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //UIGraphicsEndImageContext()
        
        //Create the mask
        let context = CGContext(data: nil, width: (mask.cgImage?.width)!, height: (mask.cgImage?.height)!, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.alphaOnly.rawValue).rawValue)
        context?.draw(mask.cgImage!, in: CGRect(x: 0, y: 0, width: mask.size.width * mask.scale, height: mask.size.height * mask.scale))
        let maskRef: CGImage = context!.makeImage()!
        
        //Mask the image
        let masked: CGImage = iconBackground.cgImage!.masking(maskRef)!
        
        //Finished
        return UIImage(cgImage: masked, scale: mask.scale, orientation: mask.imageOrientation)
    }
    
    
    func maskedImage(_ color: UIColor, withNonAlphaMask mask: UIImage) -> UIImage {
        //First draw the background color into an image
        UIGraphicsBeginImageContextWithOptions(mask.size, false, mask.scale)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: mask.size.width, height: mask.size.height))
        let iconBackground: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Create the mask
        let maskRef: CGImage = CGImage(maskWidth: mask.cgImage!.width, height: mask.cgImage!.height, bitsPerComponent: mask.cgImage!.bitsPerComponent, bitsPerPixel: mask.cgImage!.bitsPerPixel, bytesPerRow: mask.cgImage!.bytesPerRow, provider: mask.cgImage!.dataProvider!, decode: nil, shouldInterpolate: false)!
        
        //Mask the image
        let masked: CGImage = iconBackground.cgImage!.masking(maskRef)!
        
        //Finished
        return UIImage(cgImage: masked, scale: mask.scale, orientation: mask.imageOrientation)
    }
    
    
    func alphaMaskImage(_ mask: UIImage) -> UIImage {
        let maskRef = mask.cgImage
        let mask = CGImage(maskWidth: (maskRef?.width)!,
                           height: (maskRef?.height)!,
                           bitsPerComponent: (maskRef?.bitsPerComponent)!,
                           bitsPerPixel: (maskRef?.bitsPerPixel)!,
                           bytesPerRow: (maskRef?.bytesPerRow)!,
                           provider: (maskRef?.dataProvider!)!, decode: nil, shouldInterpolate: true)
        
        var imageWithAlpha = (self.copy() as? UIImage ?? UIImage()).cgImage
        

        
        //哈哈哈哈哈哈哈，每次都添加通道，不然 70％ 几率崩溃
        //if (CGImageGetAlphaInfo(imageWithAlpha) == .None) {
        imageWithAlpha = addAlphaChannel(imageWithAlpha!)
        //}
        let masked = imageWithAlpha?.masking(mask!)
        return UIImage(cgImage: masked!)
    }
    
    func addAlphaChannel(_ sourceImage: CGImage) -> CGImage {
        let width =  sourceImage.width
        let height =  sourceImage.height
        let colorSpace =  CGColorSpaceCreateDeviceRGB()
        
        let offscreenContext =  CGContext(data: nil, width: width, height: height,
                                          bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace,
                                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
        
        offscreenContext?.draw(sourceImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        return offscreenContext!.makeImage()!
    }
    
    
    class func maskedImage(image: UIImage, mask: UIImage) -> UIImage {
        let maskRef = mask.cgImage
        
        let mask = CGImage(maskWidth: maskRef!.width, height: maskRef!.height, bitsPerComponent: maskRef!.bitsPerComponent, bitsPerPixel: maskRef!.bitsPerPixel, bytesPerRow: maskRef!.bytesPerRow, provider: maskRef!.dataProvider!, decode: nil, shouldInterpolate: false)
        let masked = image.cgImage!.masking(mask!)
        
        return UIImage(cgImage: masked!)
    }
    
    
    class func mImage(image:UIImage, mask:(UIImage)) -> UIImage {
        
        let imageReference = image.cgImage
        let maskReference = mask.cgImage
        
        let imageMask = CGImage(maskWidth: (maskReference?.width)!,
                                height: (maskReference?.height)!,
                                bitsPerComponent: (maskReference?.bitsPerComponent)!,
                                bitsPerPixel: (maskReference?.bitsPerPixel)!,
                                bytesPerRow: (maskReference?.bytesPerRow)!,
                                provider: (maskReference?.dataProvider!)!, decode: nil, shouldInterpolate: true)
        
        let maskedReference = imageReference?.masking(imageMask!)
        
        let maskedImage = UIImage(cgImage:maskedReference!)
        
        return maskedImage
    }
    
    func masked(with image: UIImage, position: CGPoint? = nil, inverted: Bool = false) -> UIImage {
        let position = position ??
            

            CGPoint(x: size.width/2 - image.size.width/2,
                    y: size.height/2 - image.size.height/2)
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero)
        image.draw(at: position, blendMode: inverted ? .destinationOut : .destinationIn, alpha: 1)
        return UIGraphicsGetImageFromCurrentImageContext()!
        
    }
    
    class func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        

        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))//(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    class func aImage(image:UIImage, mask:UIImage )->UIImage{
        
        let imageReference = (image.cgImage)!
        let maskReference = (mask.cgImage)!
        
        let imageMask = CGImage.init(
            maskWidth: maskReference.width
            ,height: maskReference.height
            ,bitsPerComponent: maskReference.bitsPerComponent
            ,bitsPerPixel: maskReference.bitsPerPixel
            ,bytesPerRow: maskReference.bytesPerRow
            ,provider: maskReference.dataProvider!
            ,decode: nil
            ,shouldInterpolate: true
        )
        
        
        return (UIImage(cgImage:(imageReference.masking(imageMask!))!))
    }
    
    
    class func cutImage(_ image: UIImage!, width: CGFloat, height: CGFloat) -> [[UIImage]] {
        let scale = image.scale
        
        let iconWidth: Int = Int(image.size.width / width * scale)
        let iconHeight: Int = Int(image.size.height / height * scale)
        
        var array = [[UIImage]]()
        for i in 0...Int(width)-1 {
            var secondArray = [UIImage]()
            for j in 0...Int(height)-1 {
                let rect = CGRect(x: iconWidth * i, y: iconHeight * j, width: iconWidth, height: iconHeight)
                let cgImage = image.cgImage
                let resultCG = cgImage?.cropping(to: rect)!
                let result = UIImage(cgImage: resultCG!, scale: scale, orientation: .up)
                secondArray.append(result)
            }
            array.append(secondArray)
        }
        return array
    }
    
        
    class func maskImage(image:UIImage, mask:(UIImage))->UIImage{
        
        let cgOriginalImage:CGImage = image.cgImage!
        let cgMaskImage:CGImage = mask.cgImage!
        let width = cgMaskImage.width
        let height = cgMaskImage.height

        
        let alphaInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
         /*
        
        let imageMask:CGImage = CGImage.init(maskWidth: cgMaskImage.width,
                                             height: cgMaskImage.height,
                                             bitsPerComponent: cgMaskImage.bitsPerComponent,
                                             bitsPerPixel: cgMaskImage.bitsPerPixel,
                                             bytesPerRow: cgMaskImage.bytesPerRow,
                                             provider: cgMaskImage.dataProvider!,
                                             decode: nil,
                                             shouldInterpolate: true)!
 
        
        */
       
        let bitmapInfo:CGBitmapInfo = [CGBitmapInfo.byteOrderMask, CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue)]
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        let imageMask: CGImage = CGImage.init(width: Int(width),
                                              height: Int(height),
                                              bitsPerComponent: cgMaskImage.bitsPerComponent,
                                              bitsPerPixel: cgMaskImage.bitsPerPixel,
                                              bytesPerRow: cgMaskImage.bytesPerRow,
                                              space: cgMaskImage.colorSpace!,
                                              bitmapInfo: alphaInfo,//cgMaskImage.bitmapInfo,
                                              provider: cgMaskImage.dataProvider!,
                                              decode: nil,
                                              shouldInterpolate: true,
                                              intent: CGColorRenderingIntent.defaultIntent)!
        
        ///CGBitmapInfo bitmapInfo = kCGImageAlphaNone
        
        
        let maskedImage:CGImage = cgOriginalImage.masking(imageMask)!
        
        let context = CGContext(data: nil,
                                width: Int(width),
                                height: Int(height),
                                bitsPerComponent: 8,
                                bytesPerRow: 0,
                                space: image.cgImage!.colorSpace!,
                                bitmapInfo: image.cgImage!.bitmapInfo.rawValue)!
        

        let newImage:UIImage = UIImage.init(cgImage: maskedImage)
        
        
        return newImage
        
        /*
        let context = UIGraphicsGetCurrentContext()!
        context.draw(newImage, in: image.ciI)
//        context.draw(mask!, in: rect)
        //
        UIGraphicsBeginImageContextWithOptions(newImage.size, false, 0)
        newImage.draw(in: CGRect(x: 0.0, y: 0.0, width: newImage.size.width, height: newImage.size.height))
        let finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //
        return finalImage
 */
    }
    
    func imageByApplyingMaskingBezierPath(_ path: UIBezierPath) -> UIImage {
        // Define graphic context (canvas) to paint on
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        // Set the clipping mask
        path.addClip()
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // Restore previous drawing context
        context.restoreGState()
        UIGraphicsEndImageContext()
        
        return maskedImage
    }
    
    
    class func imageByMakingWhiteBackgroundTransparent(image: UIImage) -> UIImage {
        
        //Create transparent mask
        let colorMasking: [CGFloat] = [222,255,222,255,222,255]
        UIGraphicsBeginImageContext(image.size)
        

        
        //Add mask to image and return result
        if let maskedImageRef = image.cgImage?.copy(maskingColorComponents: colorMasking) {
            UIGraphicsGetCurrentContext()!.translateBy(x: 0.0, y: image.size.height)
            UIGraphicsGetCurrentContext()!.scaleBy(x: 1.0, y: -1.0)
            UIGraphicsGetCurrentContext()?.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result!
        }
        
        return image
    }
    
    func maskWithColor(color: UIColor) -> UIImage? {
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
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    func overlayImage(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        color.setFill()
        
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        
        context!.setBlendMode(CGBlendMode.colorBurn)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context!.draw(self.cgImage!, in: rect)
        
        context!.setBlendMode(CGBlendMode.sourceIn)
        context!.addRect(rect)
        context!.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return coloredImage!
    }
    
    
    
}
