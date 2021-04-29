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
    @State var displayLabel  = false
    @State private var qrImage = UIImage(named:"Test")
    
    var body: some View {
            VStack {
                TextField("Please enter Text", text: $contentText)
                    .padding()
                    .onChange(of: contentText, perform: { value in
                        qrImage = displayImage()
                    })
                
                TextField("Please enter Label", text:$labelText)
                    .padding()
                    .onChange(of: labelText, perform: { value in
                        qrImage = displayImage()
                  })
                
                Toggle(isOn: $displayLabel) {
                    Text("Display label?")
                }.onChange(of: displayLabel, perform: { value in
                    qrImage = displayImage()
              }).padding()
                
                Spacer()
                Image(uiImage: qrImage!)
                    .resizable()
                    .frame(width: 200.0, height: 220.0)
                    .shadow(radius: 10)
                Spacer()
                Button("Print") {
                    printQR()
                }
                Spacer()

            }
            .navigationBarTitle("Create QR Code")
        
    }
    
 
    func displayImage() -> UIImage? {
        if displayLabel == true {
            let factory  = QRCodeFactory.init(contentString: contentText, labelString: labelText)
            return factory.createQRImage()

        } else {
            let factory  = QRCodeFactory.init(contentString: contentText, labelString: nil)
            return factory.createQRImage()
        }

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
  //              CreateQRCodeView(contentText: "Dies ist ein Test")
            }
        }
    }
}
