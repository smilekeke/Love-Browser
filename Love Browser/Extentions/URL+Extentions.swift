//
//  URL+Extentions.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/23.
//

import Foundation

extension URL {
    
    // MARK: static
    public static func webUrl(from text: String) -> URL? {
        
        guard var url = URL(string: text) else { return nil }

        switch url.scheme {
            
        case "http","https":
            break
            
        case .none:
            // assume http by default
            guard let urlWithScheme = URL(string: "http://" + text),
                  // only allow 2nd+ level domains or "localhost" without scheme
                  urlWithScheme.host?.contains(".") == true
            else { return nil }
            url = urlWithScheme

        default:
            return nil
            
        }

        guard url.host?.isValidHost == true, url.user == nil else { return nil }

        return url
    }

}
