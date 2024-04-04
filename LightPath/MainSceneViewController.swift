//
//  MainSceneViewController.swift
//  LightPath
//
//  Created by Yuliia on 26/03/24.
//

import Foundation
import SpriteKit

enum GraphErrors: Error {
    case edgeAlreadyExists
    case vertexNotFound
}

class MainSceneViewController {
    
    static let shared: MainSceneViewController = MainSceneViewController()
    

    private var vertexLetter: Unicode.Scalar = "A"
    
    var startVertex: Vertex?
    var endVertex: Vertex?
    
    
    @Published var graph = Graph()
    

    func createVertex(nodePosition: CGPoint) -> Vertex {
        
        let vertexNode = SKLabelNode(text: getRandomEmoji())
        vertexNode.position = nodePosition
        vertexNode.fontSize = 50
        vertexNode.name = "vertex" + String(vertexLetter)
        vertexNode.zPosition = 2
        
        let vertexText = SKLabelNode(text: String(vertexLetter))
        vertexText.fontColor = .white
        vertexText.fontSize = 30
        vertexText.fontName = "GillSans-Bold"
        vertexText.verticalAlignmentMode = .top
        vertexText.horizontalAlignmentMode = .center
        vertexText.position.y += 70
        vertexText.name = String(vertexLetter)
        vertexText.zPosition = 3
        
        vertexNode.addChild(vertexText)
                                
        let vertex = Vertex(position: nodePosition, spriteNode: vertexNode, name: vertexNode.name!)
        
        return vertex
    }
    
    func createEdge(sourceVertex: Vertex, destinationVertex: Vertex) throws -> Edge {
        let edgeNode = SKShapeNode(start: sourceVertex.spriteNode.position, end: destinationVertex.spriteNode.position)
        edgeNode.name = "edge" + sourceVertex.name + "to" + destinationVertex.name
        edgeNode.zPosition = 1
        
        let edgeWeight = getRandomWeight()
        
        let edgeText = SKLabelNode(text: String(edgeWeight))
        edgeText.fontColor = .white
        
        edgeText.fontSize = 25
        edgeText.fontName = "GillSans-Bold"
        edgeText.position.x = edgeNode.frame.midX - 20
        edgeText.position.y = edgeNode.frame.midY + 15
        edgeText.name = String(edgeWeight)
        edgeText.zPosition = 3
        
        edgeNode.addChild(edgeText)
        
        let edge = Edge(spriteNode: edgeNode, source: sourceVertex, destination: destinationVertex, weight: edgeWeight )
        
        if let _ = graph.adjacencyDict.first(where: {$0.value.contains(edge)}) {
            print("this edge already exists")
            throw GraphErrors.edgeAlreadyExists
        } else {
            return edge
        }
            
            
    }
    func dijkstraShortestPath() -> [Edge]? {
        let dijkstra = Dijkstra(graph: graph)
        
        if let vertexOne = startVertex, let vertexTwo = endVertex {
            let pathsFromStart = dijkstra.shortestPath(from: vertexOne)
            
            let shortestPathToEnd = dijkstra.shortestPath(to: vertexTwo, paths: pathsFromStart)
            
            for edge in shortestPathToEnd { // 3
                print("\(edge.source) --|\(edge.weight )|--> \(edge.destination)")
            }
            return shortestPathToEnd
        }
        return nil
    }
    
    func findStartEndVertexes(from startLetter: String, to endLetter: String) throws {
        guard let startVertex = graph.adjacencyDict.first(where: { $0.key.name == "vertex"+startLetter})?.key,
           let endVertex = graph.adjacencyDict.first(where: { $0.key.name == "vertex"+endLetter})?.key else {
            throw GraphErrors.vertexNotFound
        }
        self.startVertex = startVertex
        self.endVertex = endVertex
    }
    
    func incrementVertexLetter() {
        //TODO: add limit to the last alphabet letter
        vertexLetter = UnicodeScalar(vertexLetter.value + 1)!
    }
    
    func getRandomEmoji() -> String {
        return String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
    }
    
    func getRandomWeight() -> Double {
       let weight =  Double.random(in: 0.0 ..< 100.0)
        let roundedWeight =  (weight * 100).rounded() / 100
       return roundedWeight
    }
}
