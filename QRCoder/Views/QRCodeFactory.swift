//
//  QRCodeView.swift
//  QRCoder
//
//  Created by Holger Mayer on 29.04.21.
//

import SwiftUI

struct QRCodeFactory {
    var contentString : String?
    var labelString : String?
    
    let widthHeightRatio : CGFloat = 1.2
     
    func createQRImage() -> UIImage? {
        
        let qrImage = createQRCodeImage()
        
        return expandQRWithLabel(qrImage:qrImage)
        
    }
    
    func createQRCodeImage() -> UIImage? {
        guard let contentString = contentString else {
            return UIImage(named:"Test")
        }
 
        let filter = CIFilter(name: "CIQRCodeGenerator")
        let data = contentString.data(using: .ascii, allowLossyConversion: false)
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 2, y: 2)


        let image = filter?.outputImage?.transformed(by: transform)
        //
        // Wichtig :
        // Erst durch pndData() wird das Bild des QR-Codes erzeugt.
        // Sonst wird nichts angezeigt.
        //
        let qrImage = UIImage(ciImage: image!)
        
        return UIImage(data:qrImage.pngData()!)
    }
    func expandQRWithLabel(qrImage:UIImage?) -> UIImage? {
        guard let qrImage = qrImage else { return UIImage(named:"Test") }
        guard let labelString = labelString else { return qrImage }
        let targetSize = CGSize(width: qrImage.size.width, height: qrImage.size.height * widthHeightRatio)
        UIGraphicsBeginImageContextWithOptions(targetSize, true, 0.0)
            // get context
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return UIImage(named:"Test")
            
        }
        
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        context.fill(CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: targetSize));
            // push context to make it current
            // (need to do this manually because we are not drawing in a UIView)
        UIGraphicsPushContext(context)
        // drawing code comes here- look at CGContext reference
        // for available operations
        // this example draws the inputImage into the context
        let qrRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: qrImage.size)
        qrImage.draw(in: qrRect)
        // pop context
        UIGraphicsPopContext()
        
        let string = labelString
  //      let textTargetSize: CGSize = CGSize(width: targetSize.width, height: targetSize.height / widthHeightRatio)
        let origin: CGPoint =  CGPoint(x: 0.0, y: targetSize.height / widthHeightRatio)
        let font: UIFont = UIFont.boldSystemFont(ofSize: 10)

        let attrs: [NSAttributedString.Key:Any] = [.font: font]
        let boundingRect = string.boundingRect(with: targetSize, options: [.usesLineFragmentOrigin], attributes: attrs, context: nil)
        let textRect = CGRect(origin: origin, size: boundingRect.size)
        string.draw(with: textRect, options: [.usesLineFragmentOrigin], attributes: attrs, context: nil)
            // get a UIImage from the image context- enjoy!!!
        guard let outputImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage(named:"Test")
        }
        // clean up drawing environment
        UIGraphicsEndImageContext()
        
        return UIImage(data:outputImage.pngData()!)
    }
}

