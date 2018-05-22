//
//  Constant.swift
//  Constrictor
//
//  Created by Pedro Carrasco on 22/05/2018.
//  Copyright © 2018 Pedro Carrasco. All rights reserved.
//

import UIKit

struct Constant {

    /**
     Inverts the constant/offset sent depending on the NSLayoutAttribute.

     - Author:
     Pedro Carrasco

     - returns:
     CGFloat containing the constant final value.

     - parameters:
        - attribute: NSLayoutAttribute where the constant/offset will be applied.
        - value: Constant's value.

     - version:
     0.1.0
     */
    static func normalizeConstant(for attribute: NSLayoutAttribute, value: CGFloat) -> CGFloat {

        switch attribute {
        case .trailing, .bottom, .right,
             .trailingMargin, .bottomMargin, .rightMargin,
             .firstBaseline, .lastBaseline:
            return -value

        case .left, .top, .leading,
             .height, .width,
             .centerY, .centerX,
             .leftMargin, .topMargin, .leadingMargin,
             .centerXWithinMargins, .centerYWithinMargins,
             .notAnAttribute:
            return value
        }
    }
}