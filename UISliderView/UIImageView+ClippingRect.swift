//
//  UIImageView+Clipping.swift
//  UISliderView
//
//  Created by Aleksey Pleshkov on 22.04.2020.
//  Copyright © 2020 Aleksey Pleshkov. All rights reserved.
//

import UIKit

extension UIImageView {
  
    var contentClippingRect: CGRect {
        guard
          let image = image,
          contentMode == .scaleAspectFit,
          image.size.width > 0 && image.size.height > 0
          else { return frame }

        let scale: CGFloat
      
        if image.size.width > image.size.height {
            scale = frame.width / image.size.width
        } else {
            scale = frame.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (frame.width - size.width) / 2.0
        let y = (frame.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
