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
        VStack(spacing: 0) {
            SpriteView(scene: self.mainScene)
                .statusBar(hidden: true)
                .ignoresSafeArea()
            HStack(spacing: 25) {
                 Spacer()
                
                Text("From:")
                    .opacity(0.8)
                
                TextField("", text: $startVertexLetter)
                    .frame(width: 100, height: 80)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 30.0)
                            .fill(.thinMaterial)
                            .frame(width: 120, height: 80)
                            .preferredColorScheme(.dark)
                            .overlay(RoundedRectangle(cornerRadius: 30.0).stroke(.purple, lineWidth: 2))
                            .background(textFieldBackgroundColor.opacity(0.8).clipShape(RoundedRectangle(cornerRadius: 30)))
                    })
                    .onChange(of: startVertexLetter, {
                        self.startVertexLetter = String(startVertexLetter.prefix(1))
                    })
                
                Spacer()
                
                Text("To:")
                    .opacity(0.8)
                
                TextField("", text: $endVertexLetter)
                    .frame(width: 100, height: 80)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 30.0)
                            .fill(.thinMaterial)
                            .frame(width: 120, height: 80)
                            .overlay(RoundedRectangle(cornerRadius: 30.0).stroke(.purple, lineWidth: 2))
                            .background(textFieldBackgroundColor.opacity(0.8).clipShape(RoundedRectangle(cornerRadius: 30)))
                    })
                    .onChange(of: endVertexLetter, {
                        self.endVertexLetter = String(endVertexLetter.prefix(1))
                    })
                
            
                
                Spacer()
                
                
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
                    Text("Find Path")
                        .padding(30)
                })
                .background() {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.ultraThickMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 30.0).stroke(.purple, lineWidth: 4))
                }
                .padding()
                
                
                Spacer()
            }.font(.title)
            .fontWeight(.bold)
            .fontWidth(.expanded)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, 60)
            .padding(.horizontal, 30)
            .background {
                Rectangle().fill(.thinMaterial)
            }
            
        }.background(content: {
            Image("background")
        })
        .ignoresSafeArea()
    }
}




#Preview {
    GraphCanvasView()
}
