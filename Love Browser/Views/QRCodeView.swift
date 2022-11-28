//
//  QRCodeView.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/28.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var urlString: String
    
    var body: some View {
        
        Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
        
        VStack {
            
            Text("QRCode")
            
            Image(uiImage: generateQRCode(from: urlString))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
        }
        
    }
    
    func generateQRCode(from string: String) -> UIImage {
        
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
    

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}


struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView(urlString: "")
    }
}
