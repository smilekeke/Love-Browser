//
//  SegmentModel.swift
//  Love Browser
//
//  Created by 豆子 on 2023/4/13.
//

import Foundation
import SwiftUI

struct SegmentModel: Codable {
    
    var label: String
    var items: [ListModel]?
    var isSelected: Bool?
    
}

struct ListModel: Codable {
    
    var cover: String?
    var title: String?
    var url: String?

}
