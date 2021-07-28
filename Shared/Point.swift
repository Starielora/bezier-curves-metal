//
//  Point.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 29/07/2021.
//

import ModelIO
import MetalKit

class Point : Model {

    let size: Float = 0.05
    
    init(device: MTLDevice, library: MTLLibrary)
    {
        let allocator = MTKMeshBufferAllocator(device: device)
        let mdlMesh = MDLMesh(sphereWithExtent: [size, size, size], segments: [10, 10], inwardNormals: false, geometryType: .triangles, allocator: allocator)
        super.init(mdlMesh: mdlMesh, device: device, library: library)
    }
}
