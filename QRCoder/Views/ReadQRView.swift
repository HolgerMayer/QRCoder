//
//  ReadQRView.swift
//  QRCoder
//
//  Created by Holger Mayer on 26.04.21.
//

import SwiftUI
import CodeScanner

struct ReadQRView: View {
    @State var isPresentingScanner = false
    @State var scannedCode: String?

       var body: some View {
        VStack(spacing: 10) {
            if self.scannedCode != nil {
                NavigationLink("Next page", destination: Text(scannedCode!), isActive: .constant(true)).hidden()
            }
            Button("Scan Code") {
                self.isPresentingScanner = true
            }
            .sheet(isPresented: $isPresentingScanner) {
                self.scannerSheet
            }
            
        }.navigationBarTitle("Scan QR Code")

       }

       var scannerSheet : some View {
           CodeScannerView(
               codeTypes: [.qr],
               completion: { result in
                   if case let .success(code) = result {
                       self.scannedCode = code
                       self.isPresentingScanner = false
                   }
               }
           )
       }
}

struct ReadQRView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReadQRView()
        }
    }
}
