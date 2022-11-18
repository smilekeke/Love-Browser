//
//  Theme.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import Foundation
import SwiftUI

protocol Theme {
    
    var imageColor: String { set get}
    var placeHolderColor: Color { set get}
    var textColor: Color { set get}
    var textFieldColor: Color { set get }
    var BottomBarColor: Color { set get }
    
}
