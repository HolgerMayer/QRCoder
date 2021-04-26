//
//  ImageViewer.swift
//  QRCoder
//
//  Created by Holger Mayer on 26.04.21.
//

import SwiftUI
import UIKit

struct ImageViewer: View {
    var image : UIImage?
    var body: some View {
        Image(uiImage: image!).shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

struct ImageViewer_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewer(image:UIImage(named: "Test"))
    }
}
