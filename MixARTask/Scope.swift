//
//  Scope.swift
//  MixARTask
//
//  Created by Табункин Вадим on 10.05.2023.
//

import ARKit
import SpriteKit
import SceneKit

class Scope: SCNNode {

    override init() {
        super.init()
        let arKitBox = SCNSphere(radius: 0.025)
        self.geometry = arKitBox
        let shape = SCNPhysicsShape(geometry: arKitBox, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        self.geometry?.materials  = [material]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
