//
//  ViewWithRoundedCornersAndShadow.swift
//  iNews DE
//
//  Created by MedAmine on 10/27/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class ViewWithRoundedCornersAndShadow: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 15
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }

}
