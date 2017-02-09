//
//  circleView.swift
//  social-app
//
//  Created by Ethan Fox on 2/9/17.
//  Copyright © 2017 Ethan Fox. All rights reserved.
//

import Foundation
import UIKit

class circleView: UIImageView {
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.width / 2
    }
    
}
