//
//  Drawable.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 28/07/2021.
//

import MetalKit

protocol Drawable {
    func draw(renderEncoder: MTLRenderCommandEncoder, mvp: inout MVPMatrices)
}
