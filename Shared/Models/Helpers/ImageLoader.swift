//
//  ImageLoader.swift
//  Grow iOS
//
//  Created by Ryan Thally on 8/29/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import Foundation
import SwiftUI

struct ImageLoader {
    let imageName: String
    var uiImage: UIImage
    var image: Image
    
    init?(_ imageName: String) {
        self.imageName = imageName
        if let bundleImage = UIImage(named: imageName) {
            self.uiImage = bundleImage
            self.image = Image(imageName)
        } else if let systemImage = UIImage(systemName: imageName) {
            self.uiImage = systemImage
            self.image = Image(systemName: imageName)
        } else {
            return nil
        }
    }
}
