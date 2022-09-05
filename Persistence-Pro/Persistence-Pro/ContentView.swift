//
//  ContentView.swift
//  Persistence-Pro
//
//  Created by Rafael Carvalho on 05/09/22.
//

import SwiftUI
import RealityKit
import ARKit

class Coordinator: NSObject, ARSessionDelegate {
    
    var arView: ARView?

    @objc func onTap(_ recognizer: UITapGestureRecognizer) {
        
        guard let arView = arView else {
            return
        }

        let location = recognizer.location(in: arView)
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let result = results.first {
            
            let anchor = AnchorEntity(raycastResult: result)
            let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [SimpleMaterial(color: .green, isMetallic: true)])
            anchor.addChild(box)
            
            arView.scene.addAnchor(anchor)
        }
    }
}

struct ContentView : View {
    
    var body: some View {
        
        return ARViewContainer().edgesIgnoringSafeArea(.all)
        
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.onTap)))
        context.coordinator.arView = arView
        arView.session.delegate = context.coordinator
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
