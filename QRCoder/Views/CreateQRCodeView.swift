//
//  CreateQRCodeView.swift
//  QRCoder
//
//  Created by Holger Mayer on 26.04.21.
//

import SwiftUI
import UIKit
import CoreGraphics

struct CreateQRCodeView: View {
    @State var contentText : String = ""
    @State var qrImage = UIImage(named:"Test")
    
    var body: some View {
            VStack {
                TextField("Please enter Text", text: $contentText).padding()
                    .onChange(of: contentText, perform: { value in
                        qrImage = generateQRCode(from: contentText)
                    })
                Spacer()
                   ImageViewer(image:qrImage)
                     .padding()
                Spacer()
                Button("Print") {
                    printQR()
                }
                Spacer()

            }
            .navigationBarTitle("Create QR Code")
        
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        let data = string.data(using: .ascii, allowLossyConversion: false)
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
    
    func expandQR() -> UIImage? {
        guard let qrImage = qrImage else { return nil }
        let targetSize = CGSize(width: qrImage.size.width, height: qrImage.size.height * 2.0)
        UIGraphicsBeginImageContextWithOptions(targetSize, true, 0.0)
            // get context
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil
            
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
        
        let string = contentText
        let textTargetSize: CGSize = CGSize(width: targetSize.width, height: targetSize.height / 2.0)
        let origin: CGPoint =  CGPoint(x: 0.0, y: targetSize.height / 2)
        let font: UIFont = UIFont.boldSystemFont(ofSize: 10)

        let attrs: [NSAttributedString.Key:Any] = [.font: font]
        let boundingRect = string.boundingRect(with: targetSize, options: [.usesLineFragmentOrigin], attributes: attrs, context: nil)
        let textRect = CGRect(origin: origin, size: boundingRect.size)
        string.draw(with: textRect, options: [.usesLineFragmentOrigin], attributes: attrs, context: nil)
            // get a UIImage from the image context- enjoy!!!
        guard let outputImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        // clean up drawing environment
        UIGraphicsEndImageContext()
        
        return UIImage(data:outputImage.pngData()!)
    }
    
    func printQR() {
        
        // UIPrintInteractionController presents a user interface and manages the printing
        let printController = UIPrintInteractionController.shared

        // UIPrintInfo contains information about the print job
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = .general
        printInfo.jobName = "myPrintJob"
        printController.printInfo = printInfo
                    
        printController.printingItem = expandQR()

        // Present print controller like usual view controller. Also completionHandler is available if needed.
        printController.present(animated: true)
    }
}

struct CreateQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        CreateQRCodeView()
        }
    }
}
