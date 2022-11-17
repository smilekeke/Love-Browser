//
//  String+Extensions.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import Foundation

extension String {

    func isVaildURL(url: String) -> Bool {
        
        let currrentURL = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$";
        
        let regextestURL = NSPredicate(format: "SELF MATCHES %@", currrentURL)
        
        return regextestURL.evaluate(with: url)
        
    }
    
}

