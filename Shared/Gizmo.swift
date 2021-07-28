//
//  Gizmo.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 28/07/2021.
//

import ModelIO
import MetalKit

class GizmoStem : Model {

    init(device: MTLDevice, library: MTLLibrary)
    {
        let allocator = MTKMeshBufferAllocator(device: device)
        let mdlMesh = MDLMesh(cylinderWithExtent: [0.025, 1, 0.025], segments: [10, 1], inwardNormals: false, topCap: true, bottomCap: true, geometryType: .triangles, allocator: allocator)
        super.init(mdlMesh: mdlMesh, device: device, library: library)
    }
}

class Gizmo : Drawable {
    let x: GizmoStem
    let y: GizmoStem
    let z: GizmoStem
    
    init(device: MTLDevice, library: MTLLibrary)
    {
        x = GizmoStem(device: device, library: library)
        x.transform.rotation.z = Float.pi / 2
        x.transform.translation.x = 0.5
        x.color = [1.0, 0.0, 0.0, 1.0]
        x.drawPrimitiveType = .triangle
        
        y = GizmoStem(device: device, library: library)
        y.transform.translation.y = 0.5
        y.color = [0.0, 1.0, 0.0, 1.0]
        y.drawPrimitiveType = .triangle
        
        z = GizmoStem(device: device, library: library)
        z.transform.rotation.x = Float.pi / 2
        z.transform.translation.z = 0.5
        z.color = [0.0, 0.0, 1.0, 1.0]
        z.drawPrimitiveType = .triangle
    }
    
    func draw(renderEncoder: MTLRenderCommandEncoder, mvp: inout MVPMatrices) {
        x.draw(renderEncoder: renderEncoder, mvp: &mvp)
        y.draw(renderEncoder: renderEncoder, mvp: &mvp)
        z.draw(renderEncoder: renderEncoder, mvp: &mvp)
    }
}
