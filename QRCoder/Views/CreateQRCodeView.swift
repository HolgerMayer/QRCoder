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
    @State var labelText : String = ""
    @State private var qrImage = UIImage(named:"Test")
    
    var body: some View {
            VStack {
                TextField("Please enter Text", text: $contentText).padding()
                    .onChange(of: contentText, perform: { value in
                        let factory  = QRCodeFactory.init(contentString: contentText, labelString: nil)
                        qrImage = factory.createQRImage()
                    })
                TextField("Please enter Label", text:$labelText).padding()
                Spacer()
                  ImageViewer(image: qrImage)
                Spacer()
                Button("Print") {
                    printQR()
                }
                Spacer()

            }
            .navigationBarTitle("Create QR Code")
        
    }
    
 
    
    func printQR() {
        
        // UIPrintInteractionController presents a user interface and manages the printing
        let printController = UIPrintInteractionController.shared

        // UIPrintInfo contains information about the print job
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = .general
        printInfo.jobName = "myPrintJob"
        printController.printInfo = printInfo
                    
        let factory  = QRCodeFactory.init(contentString: contentText, labelString: labelText)

        printController.printingItem = factory.createQRImage()

        // Present print controller like usual view controller. Also completionHandler is available if needed.
        printController.present(animated: true)
    }
}

struct CreateQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                CreateQRCodeView()
                CreateQRCodeView(contentText: "Dies ist ein Test")
            }
        }
    }
}
