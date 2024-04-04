//
//  MainScene.swift
//  LightPath
//
//  Created by Yuliia on 23/03/24.
//

import SpriteKit
import SwiftUI

class MainScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    var beginningTouchPosition: CGPoint?
    var endingTouchPosition: CGPoint?
    
    //var vertexes: [Vertex]? = []
    //var edges: [Edge]? = []
        
    
    var viewController: MainSceneViewController = MainSceneViewController.shared

    
    //MARK: - SKScene override functions
    
    // When the view is presented
    override func didMove(to view: SKView) {
        
        // add background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.name = "background"
        addChild(background)

    }
    
}

//MARK: - Gestures functionality
extension MainScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch =  touches.first
        let position = touch?.location(in: self)
        
        
        if let position = position {
            print("\n beginning touch pos \(position)")
            beginningTouchPosition = position

        }
        else {
            print("couldn't get beginning touch pos ")

        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch =  touches.first
        let endingTapPosition = touch?.location(in: self)
        
        if let position = endingTapPosition {
            
            endingTouchPosition = position
            
            //get nodes that are on ending point
            let nodesAtEndingPosition = nodes(at: position).filter({$0.name != "background"})
            
            
            if let begPosition = beginningTouchPosition {
                
                //get nodes that are on beginning point
                let nodesAtBeginningPosition = nodes(at: begPosition).filter({$0.name != "background"})
                                
                // Single tap
                if position == begPosition {
                    print("single tap")
                    
                    // No nodes at position
                    // Create vertex
                    if nodesAtEndingPosition.isEmpty {
                                                
                        let vertex = viewController.createVertex(nodePosition: position)
                       
                        print("adding vertex at \(position)")
                        
                        //adding vertex to graph
                        viewController.graph.addVertex(vertex)
                        
                        
                        //adding vertex to scene
                        addChild(vertex.spriteNode)
                        
                        //set next vertex letter
                        viewController.incrementVertexLetter()
                        
                    } else {
                        print(nodesAtEndingPosition)
                    }
                    
                    // Moving gesture
                } else {
                    print("beg and end positions aren't the same")
                    
                    // check if nodes exist on beg and ending positions
                    if !nodesAtBeginningPosition.isEmpty, !nodesAtEndingPosition.isEmpty {
                        
                        // get source and destination Vertexes nodes
                        if let sourceVertexNode = nodesAtBeginningPosition.first(where: { $0.name!.contains("vertex")} ),
                           let destinationVertexNode = nodesAtEndingPosition.first(where: { $0.name!.contains("vertex")} ){
                            
                            print("sourceVertex \(sourceVertexNode)")
                            print("destinationVertex \(destinationVertexNode)")
                            
                            let sourceVertex = viewController.graph.getVertexes().first(where: {$0.spriteNode == sourceVertexNode })
                            let destinationVertex = viewController.graph.getVertexes().first(where: {$0.spriteNode == destinationVertexNode })
                            
                            if let sourceVertex = sourceVertex, let destinyVertex = destinationVertex {
                                
                            // create Edge between 2 nodes
                                if let edge = try? viewController.createEdge(sourceVertex: sourceVertex, destinationVertex: destinyVertex) {
                                    
                                    addChild(edge.spriteNode)
                                    
                                    
                                    print("adding edge to graph")
                                    viewController.graph.addEdge(edge: edge, from: sourceVertex, to: destinyVertex)
                                    print(viewController.graph.description)
                                }
                            } else {
                                print("couldn't unwrap \(String(describing: sourceVertex)), and \(String(describing: destinationVertex))")
                            }
                            
                            

                        }
                    }
                }
            }
        }
        
        beginningTouchPosition = nil
        endingTouchPosition = nil
       
    }
}

extension MainScene {
    func showShortestPath(edges: [Edge]) {
        edges.forEach { edge in
            if let edge = self.scene?.childNode(withName: edge.spriteNode.name!) as? SKShapeNode {
                    edge.strokeColor = .magenta
                    edge.lineWidth = 7
            }
        }
    }
    
    func resetEdgesColor() {
        scene?.children.forEach({ node in
            if let edge = node as? SKShapeNode {
                edge.strokeColor = .white

            }
        })
    }
}


