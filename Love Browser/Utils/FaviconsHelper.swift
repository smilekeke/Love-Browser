//
//  FaviconsHelper.swift
//  DuckDuckGo
//
//  Copyright © 2022 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import Kingfisher

struct FaviconsHelper {
    
//    static func loadFaviconSync(forDomain domain: String?,
//                                useFakeFavicon: Bool) -> UIImage {
//
//
//            var resultImage: UIImage?
//            let image =
//            if image != nil {
//
//                resultImage = image
//
//            } else if useFakeFavicon, let domain = domain {
//
//                fake = true
//                resultImage = Self.createFakeFavicon(forDomain: domain)
//            }
//
//        return resultImage
//
//    }
    
    static func createFakeFavicon(forDomain domain: String,
                                  size: CGFloat = 192,
                                  backgroundColor: UIColor = UIColor.gray,
                                  bold: Bool = true) -> UIImage? {
        
        let cornerRadius = size * 0.125
        let fontSize = size * 0.76
        
        let imageRect = CGRect(x: 0, y: 0, width: size, height: size)

        let renderer = UIGraphicsImageRenderer(size: imageRect.size)
        let icon = renderer.image { imageContext in
            let context = imageContext.cgContext
                            
            context.setFillColor(backgroundColor.cgColor)
            context.addPath(CGPath(roundedRect: imageRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil))
            context.fillPath()
             
            let label = UILabel(frame: imageRect)
            label.font = bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
            label.textColor = UIColor.white
            label.textAlignment = .center
//            label.text = String(domain.droppingWwwPrefix().prefix(1).uppercased())
            label.text = "B"
            label.sizeToFit()
             
            context.translateBy(x: (imageRect.width - label.bounds.width) / 2,
                                y: (imageRect.height - label.font.ascender) / 2 - (label.font.ascender - label.font.capHeight) / 2)
             
            label.layer.draw(in: context)
        }
         
        return icon.withRenderingMode(.alwaysOriginal)
    }
    
}
