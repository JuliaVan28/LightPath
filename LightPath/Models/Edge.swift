//
//  Edge.swift
//  LightPath
//
//  Created by Yuliia on 24/03/24.
//

import Foundation
import SpriteKit

public enum EdgeType {
  case directed, undirected
}

class Edge:Identifiable {
    let id = UUID()
    
    var spriteNode: SKShapeNode
    
    var source: Vertex
    var destination: Vertex
    var weight: Double
    var type = EdgeType.undirected
    
    init( spriteNode: SKShapeNode, source: Vertex, destination: Vertex, weight: Double) {
        self.spriteNode = spriteNode
        self.source = source
        self.destination = destination
        self.weight = weight
    }
}

extension Edge: Equatable {
    static func == (lhs: Edge, rhs: Edge) -> Bool {
        lhs.source == rhs.source &&
        lhs.destination == rhs.destination
    }
}

extension Edge: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(source)
        hasher.combine(destination)
    }
}
