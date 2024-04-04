//
//  Graph.swift
//  LightPath
//
//  Created by Yuliia on 25/03/24.
//

import Foundation

class Graph {
    
    var adjacencyDict : [Vertex: Set<Edge>] = [:]

    func addVertex(_ vertex: Vertex) {
        
        if adjacencyDict[vertex] == nil {
            adjacencyDict[vertex] = []
        }
    }
    
    func addEdge(edge: Edge, from source: Vertex, to destination: Vertex) {
        switch edge.type {
      case .directed:
            adjacencyDict[source]?.insert(edge)
            
      case .undirected:
            adjacencyDict[source]?.insert(edge)
            let backwardEdge = Edge(spriteNode: edge.spriteNode, source: destination, destination: source, weight: edge.weight)
            adjacencyDict[destination]?.insert(backwardEdge)
      }
    }
    
     func getWeight(from source: Vertex, to destination: Vertex) -> Double? {
      guard let edges = adjacencyDict[source] else {
        return nil
      }
      
      for edge in edges {
        if edge.destination == destination {
          return edge.weight
        }
      }
      
      return nil
    }
    
    
    func getEdges(from source: Vertex) -> [Edge] {
        if let edges = adjacencyDict[source] {
            return Array(edges)
        }
        return []
    }
    
    func getVertexes() -> [Vertex] {
        Array(adjacencyDict.keys)
    }
    
    
    
    var description: CustomStringConvertible {
      var result = ""
      for (vertex, edges) in adjacencyDict {
        var edgeString = ""
        for (index, edge) in edges.enumerated() {
          if index != edges.count - 1 {
              edgeString.append("\(edge.destination.description), ")
          } else {
              edgeString.append("\(edge.destination.description)")
          }
        }
          result.append("\(vertex.name) ---> [ \(edgeString) ] \n ")
      }
      return result
    }
}
