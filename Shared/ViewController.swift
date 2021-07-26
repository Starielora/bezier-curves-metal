//
//  ViewController.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 26/07/2021.
//

import Cocoa
import MetalKit

class ViewController : NSViewController {

    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        guard let metalView = view as? MTKView else {
            fatalError("Metal view not set in storyboard.")
        }

        renderer = Renderer(metalView: metalView)
    }
}
