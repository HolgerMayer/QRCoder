//
//  CreateQRCodeView.swift
//  QRCoder
//
//  Created by Holger Mayer on 26.04.21.
//

import SwiftUI
import UIKit

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
        let uiImage = UIImage(ciImage: image!)

        return UIImage(data:uiImage.pngData()!)
    }
    
    func printQR() {
        
        // UIPrintInteractionController presents a user interface and manages the printing
        let printController = UIPrintInteractionController.shared

        // UIPrintInfo contains information about the print job
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = .general
        printInfo.jobName = "myPrintJob"
        printController.printInfo = printInfo
                    
        printController.printingItem = self.qrImage

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
