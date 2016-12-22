//
//  CircleView.swift
//  Strana-Social
//
//  Created by Jordan Cech on 12/20/16.
//  Copyright © 2016 Strana LLC. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
        
    }

}
