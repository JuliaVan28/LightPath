//
//  Vertex.swift
//  LightPath
//
//  Created by Yuliia on 23/03/24.
//

import Foundation
import SpriteKit

class Vertex: Identifiable {
    let id = UUID()

    var position: CGPoint
    var spriteNode: SKNode
    var name: String
    
    
    init(position: CGPoint, spriteNode: SKNode, name: String) {
        self.position = position
        self.spriteNode = spriteNode
        self.name = name
    }
 

    
}

extension Vertex: Equatable {
    static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        lhs.spriteNode == rhs.spriteNode
    }
}

extension Vertex: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(spriteNode)
    }
}

extension Vertex: Comparable {
    static func < (lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.id < rhs.id
    }
    
    
}


extension Vertex: CustomStringConvertible {
  public var description: String {
    return "\(name)"
  }
}

