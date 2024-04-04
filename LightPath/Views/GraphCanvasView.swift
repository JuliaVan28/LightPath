//
//  GraphCanvasView.swift
//  LightPath
//
//  Created by Yuliia on 22/03/24.
//

import SwiftUI
import SpriteKit

struct GraphCanvasView: View {
    @StateObject var mainScene: MainScene = {
        let scene = MainScene()
        print("Main scene is created")
        
        scene.view?.ignoresSiblingOrder = true
        
        scene.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        scene.scaleMode = .fill
        
        return scene
    }()
    
    @State var startVertexLetter: String = ""
    @State var endVertexLetter: String = ""
    @State var textFieldBackgroundColor: Color = .clear
    
    var body: some View {
        
        GeometryReader { geom in
            ZStack {
                SpriteView(scene: self.mainScene)
                    .statusBar(hidden: true)
                    .ignoresSafeArea()
                //HStack(spacing: 25) {
                   //  Spacer()
                    
                   /* Text("From:")
                        .opacity(0.8)
                    */
                VStack {
                    Spacer()
                    HStack {
                            TextField("From", text: $startVertexLetter)
                                .frame(width: 150, height: 80)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .fill(.thinMaterial)
                                        .frame(width: 150, height: 80)
                                        .overlay(RoundedRectangle(cornerRadius: 25.0).stroke(.purple, lineWidth: 3))
                                        .background(textFieldBackgroundColor.opacity(0.8).clipShape(RoundedRectangle(cornerRadius: 25)))
                                })
                                .onChange(of: startVertexLetter, {
                                    self.startVertexLetter = String(startVertexLetter.prefix(1))
                                })
                            
                            // Spacer()
                            
                            /*  Text("To:")
                             .opacity(0.8)
                             */
                            Image(systemName: "arrow.right")
                            
                            TextField("To", text: $endVertexLetter)
                                .frame(width: 150, height: 80)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .fill(.thinMaterial)
                                        .frame(width: 150, height: 80)
                                        .overlay(RoundedRectangle(cornerRadius: 25.0).stroke(.purple, lineWidth: 3))
                                        .background(textFieldBackgroundColor.clipShape(RoundedRectangle(cornerRadius: 25)))
                                })
                                .onChange(of: endVertexLetter, {
                                    self.endVertexLetter = String(endVertexLetter.prefix(1))
                                })
                            
                            
                            
                            // Spacer()
                            
                            
                            Button(action: {
                                mainScene.resetEdgesColor()
                                do {
                                    try mainScene.viewController.findStartEndVertexes(from: startVertexLetter, to: endVertexLetter)
                                    
                                    if let shortestPath = mainScene.viewController.dijkstraShortestPath() {
                                        mainScene.showShortestPath(edges: shortestPath)
                                    }
                                } catch {
                                    print("vertexes aren't found")
                                    textFieldBackgroundColor = .red
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        textFieldBackgroundColor = .clear
                                    }
                                }
                                
                                
                            }, label: {
                                Text("Find path")
                                //Image(systemName: "play.fill")
                                    .padding(25)
                            })
                            .background() {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.purple)
                                // .fill(.ultraThickMaterial)
                                //.overlay(RoundedRectangle(cornerRadius: 30.0).stroke(.purple, lineWidth: 4))
                            }
                            .padding()
                            
                        }
                        .frame(height: geom.size.height * 0.13)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                       
                        .padding(.horizontal, geom.size.width * 0.03)
                        .background {
                            RoundedRectangle(cornerRadius: 40.0, style: .continuous)
                                .fill(.ultraThinMaterial)
                    }
                }.padding(.bottom, geom.size.height * 0.06)
                    
                   // Spacer()
                }
                
                
                
       //
        .preferredColorScheme(.dark)
        } .ignoresSafeArea()
    }
}




#Preview {
    GraphCanvasView()
}
