//
//  SKShapeNode+Ext.swift
//  LightPath
//
//  Created by Yuliia on 26/03/24.
//

import Foundation
import SpriteKit

extension SKShapeNode {
    convenience init(start: CGPoint,
                     end: CGPoint,
                     strokeColor: UIColor = .lightGray,
                     lineWidth: CGFloat = 2.0) {
        self.init()

        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: end)

        self.path = path
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
    }
}
