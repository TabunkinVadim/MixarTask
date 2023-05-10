//
//  ViewController.swift
//  MixARTask
//
//  Created by Табункин Вадим on 07.05.2023.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    private var speed: Float = 10
    private var cubes: [Cube] = []{ didSet {
        setButtoms()
    }}

    private var sceneView: ARSCNView = {
        $0.toAutoLayout()
        return $0
    }( ARSCNView())

    private lazy var addXButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "arrow.up.square.fill")!, color: .blue, cornerRadius: 0) {
        for cube in self.cubes {
            cube.removeAllActions()
            cube.runAction(SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(-self.speed, 0, 0), duration: 20)))
        }
    } actionUp: {
        for cube in self.cubes {
            cube.removeAllActions()
        }
    }

    private lazy var turnDounXButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "arrow.down.square.fill")!, color: .blue, cornerRadius: 0) {
        for cube in self.cubes {
            cube.removeAllActions()
            cube.runAction(SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(self.speed, 0, 0), duration: 20)))
        }
    } actionUp: {
        for cube in self.cubes {
            cube.removeAllActions()
        }
    }

    private lazy var addZButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "arrow.right.square.fill")!, color: .blue, cornerRadius: 0) {
        for cube in self.cubes {
            cube.removeAllActions()
            cube.runAction(SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(0, 0, -self.speed), duration: 20)))
        }
    } actionUp: {
        for cube in self.cubes {
            cube.removeAllActions()
        }
    }

    private lazy var turnDounZButtom = UIElementFactory().addIconButtom(icon: UIImage(systemName: "arrow.left.square.fill")!, color: .blue, cornerRadius: 0) {
        for cube in self.cubes {
            cube.removeAllActions()
            cube.runAction(SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(0, 0, self.speed), duration: 20)))
        }
    } actionUp: {
        for cube in self.cubes {
            cube.removeAllActions()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene.physicsWorld.contactDelegate = self
        sceneView.delegate = self
        setButtoms()
        addtap()
        addlongtap()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Markers", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isAutoFocusEnabled = true
        configuration.accessibilityElementsHidden = false
        configuration.detectionImages = referenceImages
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    private func addtap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.setCube))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(tap)
    }

    private func addlongtap() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.removeCube))
        tap.delegate = self
        self.sceneView.addGestureRecognizer(tap)
    }

    private func layout() {
        view.addSubviews(sceneView)
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        sceneView.addSubviews(addXButtom, turnDounXButtom, addZButtom, turnDounZButtom)
        NSLayoutConstraint.activate([
            addXButtom.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor),
            addXButtom.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            addXButtom.widthAnchor.constraint(equalToConstant: 100),
            addXButtom.heightAnchor.constraint(equalToConstant: 100),
        ])

        NSLayoutConstraint.activate([
            turnDounXButtom.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor),
            turnDounXButtom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            turnDounXButtom.widthAnchor.constraint(equalToConstant: 100),
            turnDounXButtom.heightAnchor.constraint(equalToConstant: 100),
        ])

        NSLayoutConstraint.activate([
            turnDounZButtom.centerYAnchor.constraint(equalTo: sceneView.centerYAnchor),
            turnDounZButtom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            turnDounZButtom.widthAnchor.constraint(equalToConstant: 100),
            turnDounZButtom.heightAnchor.constraint(equalToConstant: 100),
        ])

        NSLayoutConstraint.activate([
            addZButtom.centerYAnchor.constraint(equalTo: sceneView.centerYAnchor),
            addZButtom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addZButtom.widthAnchor.constraint(equalToConstant: 100),
            addZButtom.heightAnchor.constraint(equalToConstant: 100),
        ])
    }

    private func setButtoms() {
        if cubes.count == 0 {
            addZButtom.isHidden = true
            addXButtom.isHidden = true
            turnDounZButtom.isHidden = true
            turnDounXButtom.isHidden = true
        } else {
            addZButtom.isHidden = false
            addXButtom.isHidden = false
            turnDounZButtom.isHidden = false
            turnDounXButtom.isHidden = false
        }
    }

    @objc private func setCube(tapGesture: UITapGestureRecognizer) {
        guard let sceneView = tapGesture.view as? ARSCNView else { return }
        let tapLocation = tapGesture.location(in: sceneView)
        if let node = sceneView.hitTest(tapLocation).first?.node {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor(red:.random(in: 0...1), green: .random(in: 0...1), blue:  .random(in: 0...1), alpha: 1.0)
            node.geometry?.materials  = Array(repeating: material, count: 6)
        } else {
            guard let hitTestResult = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent).first else { return }
            let cube = Cube()
            cube.position = SCNVector3(x: hitTestResult.worldTransform.columns.3.x, y: hitTestResult.worldTransform.columns.3.y, z: hitTestResult.worldTransform.columns.3.z)
            cubes.append(cube)
            sceneView.scene.rootNode.addChildNode(cube)
        }
    }

    @objc private func removeCube (tapGesture: UILongPressGestureRecognizer) {
        if cubes.count > 0 {
            let tapLocation = tapGesture.location(in: sceneView)
            if let node = sceneView.hitTest(tapLocation).first?.node {
                for (index,cube) in cubes.enumerated() {
                    if cube === node {
                        node.removeFromParentNode()
                        cubes.remove(at: index)
                    }
                }
            }
        }
    }
}

//MArk:ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARImageAnchor else { return }
        DispatchQueue.main.async {
            let scope = Scope()
            scope.position = SCNVector3( 0.0, 0.0, 0.0)
            node.addChildNode(scope)
            self.speed = self.speed * 2
        }
    }
}

//MArk:SCNPhysicsContactDelegate
extension ViewController: SCNPhysicsContactDelegate {
}
