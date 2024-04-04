//
//  Dijkstra.swift
//  LightPath
//
//  Created by Yuliia on 02/04/24.
//

import Foundation
import HeapModule

enum Visit {
  case start // 1
  case edge(Edge) // 2
}

class Dijkstra {
    
    let graph: Graph
    
    init(graph: Graph) {
        self.graph = graph
    }
    
    private func route( to endVertex: Vertex, with paths: [Vertex: Visit]) -> [Edge] {
        var curVertex = endVertex
        var path: [Edge] = []
        
        while let visit = paths[curVertex], case .edge(let edge) = visit {
            path = [edge] + path
            // backtracking
            curVertex = edge.source
        }
        
        return path
    }
    
    private func distance (to endVertex: Vertex, with paths: [Vertex: Visit]) -> Double {
        let path = route(to: endVertex, with: paths)
        let distances = path.compactMap({ $0.weight })
        
        return distances.reduce(0.0, +)
    }
    
    func shortestPath(from startVertex: Vertex) -> [Vertex: Visit] {
        var paths: [Vertex : Visit] = [startVertex : .start]
        
        var priorityHeap = PriorityHeap<Vertex>(sort: {
            self.distance(to: $0, with: paths) < self.distance(to: $1, with: paths)
        })
        
        priorityHeap.insert(startVertex)
        
        while let vertex = priorityHeap.remove() {
            for edge in graph.getEdges(from: vertex) {
                if paths[edge.destination] == nil ||
                    distance(to: vertex, with: paths) + edge.weight < distance(to: edge.destination, with: paths) {
                    paths[edge.destination] = .edge(edge)
                    priorityHeap.insert(edge.destination)
                }
            }
        }
        
        return paths
    }
    
    public func shortestPath(to destination: Vertex,
                             paths: [Vertex : Visit]) -> [Edge] {
      return route(to: destination, with: paths)
    }
}
