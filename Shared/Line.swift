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
    private let camera: MDLCamera // TODO implement rotation properly
    
    init(device: MTLDevice, library: MTLLibrary)
    {
        let allocator = MTKMeshBufferAllocator(device: device)
        let mdlMesh = MDLMesh.newCylinder(withHeight: 1, radii: [radii, radii], radialSegments: 10, verticalSegments: 1, geometryType: .triangles, inwardNormals: false, allocator: allocator)
        camera = MDLCamera()
        super.init(mdlMesh: mdlMesh, device: device, library: library)
    }
    
    func move(p1: SIMD3<Float>, p2: SIMD3<Float>)
    {
        let d = sqrt( pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2) + pow(p2.z - p1.z, 2) ) // TODO is already implemented in SIMD?
        camera.look(at: p1, from: ((p1+p2)/2))
        mdlMesh.transform = camera.transform
        transform.scale.y = d
        transform.rotation.x += Float.pi/2
    }
}
