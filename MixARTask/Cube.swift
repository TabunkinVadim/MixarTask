//
//  Cube.swift
//  MixARTask
//
//  Created by Табункин Вадим on 08.05.2023.
//

import ARKit
import SpriteKit
import SceneKit

class Cube: SCNNode {
    override init() {
        super.init()
        let logo = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        self.geometry = logo
        let shape = SCNPhysicsShape(geometry: logo, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemBlue
        self.geometry?.materials  = Array(repeating: material, count: 6)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
