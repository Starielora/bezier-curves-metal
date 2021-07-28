//
//  Grid.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 28/07/2021.
//

import ModelIO
import MetalKit

class Grid : Model {
    init(device: MTLDevice, library: MTLLibrary)
    {
        let allocator = MTKMeshBufferAllocator(device: device)
        let mdlMesh = MDLMesh(planeWithExtent: [100, 100, 100], segments: [100, 100], geometryType: .lines, allocator: allocator)
        super.init(mdlMesh: mdlMesh, device: device, library: library)
        
        (mdlMesh.transform as! MDLTransform).rotation = [0.0, 0.0, Float.pi/2]
        drawPrimitiveType = .line
        color = [0.0, 1.0, 1.0, 0.0]
    }
}
