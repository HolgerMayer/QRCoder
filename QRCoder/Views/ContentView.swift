//
//  ContentView.swift
//  QRCoder
//
//  Created by Holger Mayer on 26.04.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
     
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: CreateQRCodeView()) {
                    Text("Create Code")
                }
                Spacer()
                NavigationLink(destination: ReadQRView()) {
                    Text("Scan Code")
                }
                Spacer()
            }
                .navigationBarTitle("QR Code")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
