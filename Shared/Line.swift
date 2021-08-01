//
//  Line.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 29/07/2021.
//

import ModelIO
import MetalKit

class Line : Model {
    
    private let radii: Float = 0.01
    
    init(device: MTLDevice, library: MTLLibrary)
    {
        let allocator = MTKMeshBufferAllocator(device: device)
        let mdlMesh = MDLMesh.newCylinder(withHeight: 1, radii: [radii, radii], radialSegments: 10, verticalSegments: 1, geometryType: .triangles, inwardNormals: false, allocator: allocator)
        super.init(mdlMesh: mdlMesh, device: device, library: library)
    }
    
    var nanos: [UInt64] = []
    
    func move(p1: SIMD3<Float>, p2: SIMD3<Float>)
    {
        let lineLength = simd_distance(p1, p2)
        let translationVector = SIMD4<Float>((p2+p1)/2, 1)
        let lineDirection = simd_normalize(p2 - p1)

        let translation = simd_float4x4([1,0,0,0], [0,1,0,0], [0,0,1,0], translationVector)
        let scale = simd_float4x4([1,0,0,0], [0,lineLength,0,0], [0,0,1,0], [0,0,0,1])
        let rotation = simd_float4x4(simd_quatf(from: [0,1,0], to: lineDirection))
        transform.matrix = translation * rotation * scale
    }
}
