//
//  Player.swift
//  The_Ruins
//
//  Created by mai nguyen on 1/3/22.
//

import Foundation
import  SceneKit

enum PlayerAnimationType {
    case walk
    case attack1
    case dead
    
}

class Player:SCNNode {
    
    //nodes
    private var daeHolderNode = SCNNode()
    private var characterNode:SCNNode!
    private var collider: SCNNode!
    
    //animations
    private var walkAnimation = CAAnimation()
    private var attack1Animation = CAAnimation()
    private var deadAnimation = CAAnimation()
    
    //movement
    private var previousUpdateTime = TimeInterval(0.0)
    private var isWalking: Bool = false {
        
        didSet {
            
            if oldValue != isWalking {
                
                if isWalking {
                    
                    characterNode.addAnimation(walkAnimation, forKey: "walk")
            
                } else {
                    
                    characterNode.removeAnimation(forKey: "walk", blendOutDuration: 0.2)
                }
            }
        }
    }
    
    private var directionAngle: Float = 0.0 {
        didSet{
            if directionAngle != oldValue {
                runAction(SCNAction.rotateTo(x: 0.0, y: CGFloat(directionAngle), z: 0.0, duration: 0.1, usesShortestUnitArc: true))
            }
        }
    }
    
    //collisions
    var replacementPosition:SCNVector3 = SCNVector3Zero
    private var activeWeaponCollideNodes = Set<SCNNode>()
    
    //battle
    
    //MARK: - initialization
    override init() {
        super.init()
        setupModel()
        loadAnimation()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupModel() {
        
        //load dae childs
        let playerURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Hero/idle", withExtension: "dae")
        let playerScene = try! SCNScene(url: playerURL!, options: nil)
        
        for child in playerScene.rootNode.childNodes {
            
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)
        
        //set mesh name
        characterNode = daeHolderNode.childNode(withName: "Bip01", recursively: true)!
    }
    
    //MARK: - animations
    private func loadAnimation() {
        
        loadAnimation(animationType: .walk, inSceneNamed: "art.scnassets/Scenes/Hero/walk", withIdentifier: "WalkID")
        
        loadAnimation(animationType: .attack1, inSceneNamed: "art.scnassets/Scenes/Hero/attack", withIdentifier: "attackID")
        
        loadAnimation(animationType: .dead, inSceneNamed: "art.scnassets/Scenes/Hero/die", withIdentifier: "DeathID")
        
    }
    private func loadAnimation(animationType: PlayerAnimationType, inSceneNamed scene: String, withIdentifier identifier: String) {
        let sceneURL = Bundle.main.url(forResource: scene, withExtension: "dae")!
        let sceneSource = SCNSceneSource(url: sceneURL, options: nil)!
        
        let animationObject:CAAnimation = sceneSource.entryWithIdentifier(identifier, withClass: CAAnimation.self)!
        
        
        animationObject.delegate = self
        animationObject.fadeInDuration = 0.2
        animationObject.fadeOutDuration = 0.2
        animationObject.usesSceneTimeBase = false
        animationObject.repeatCount = 0
        
        switch animationType {
        case .walk:
            animationObject.repeatCount = Float.greatestFiniteMagnitude
            walkAnimation = animationObject
        case .dead:
            animationObject.isRemovedOnCompletion = false
            deadAnimation = animationObject
            
        case .attack1:
        animationObject.setValue("attack1", forKey: "animationId")
        attack1Animation = animationObject
        }
    }
    
    //MARK:- movement
    
    func walkInDirection(_ direction:float3, time: TimeInterval, scene: SCNScene) {
        
        
        if previousUpdateTime == 0.0 { previousUpdateTime = time }
        
        let deltaTime = Float(min(time - previousUpdateTime, 1.0/60.0))
        let characterSpeed = deltaTime * 1.3
        previousUpdateTime = time
        
        let initialPosition = position
        
        //move
        if direction.x != 0.0 && direction.z != 0.0 {
            
            //move character
            let pos = float3(position)
            position = SCNVector3(pos+direction * characterSpeed)
            
            //update angle
            directionAngle = SCNFloat(atan2f(direction.x, direction.z))
            
            isWalking = true
            
        } else {
            
            isWalking = false
        }
        
        //update altidute
        var pos = position
        var endpoint0 = pos
        var endpoint1 = pos
        
        endpoint0.y -= 0.1
        endpoint1.y += 0.08
        
        let results = scene.physicsWorld.rayTestWithSegment(from: endpoint1, to: endpoint0, options: [.collisionBitMask: BitmaskWall, .searchMode: SCNPhysicsWorld.TestSearchMode.closest])
        
        if let result = results.first {
            
            let groundAltidute = result.worldCoordinates.y
            pos.y = groundAltidute
            
            position = pos
      
        } else {
            
            position = initialPosition
        }
    }
    
    func setupCollider(with scale : CGFloat) {
        let geometry = SCNCapsule(capRadius: 47, height: 165)
        geometry.firstMaterial?.diffuse.contents = UIColor.red
        
        collider = SCNNode(geometry: geometry)
        collider.position = SCNVector3Make(0.0, 140.0, 0.0)
        collider.name = "collider"
        collider.opacity = 0.0
        
        let physicsGeometry = SCNCapsule(capRadius: 47*scale, height: 165*scale)
        let physicsShape = SCNPhysicsShape(geometry: physicsGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = BitmaskPlayer 
        collider.physicsBody!.contactTestBitMask = BitmaskWall
        
        addChildNode(collider)
    }
}

extension Player: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // TODO later
    }
}
