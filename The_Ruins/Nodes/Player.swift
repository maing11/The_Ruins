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
    
    //animations
    private var walkAnimation = CAAnimation()
    private var attack1Animation = CAAnimation()
    private var deadAnimation = CAAnimation()
    
    //MARK: - initialization
    override init() {
        super.init()
        setupModel()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupModel() {
        // load dae childs
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
        loadAnimation(animationType: .walk, inSceneNamed: "art.scnassets/Scenes/Hero/attack", withIdentifier: "attackID")
        loadAnimation(animationType: .walk, inSceneNamed: "art.scnassets/Scenes/Hero/die", withIdentifier: "DeathID")
    }
    private func loadAnimation(animationType: PlayerAnimationType,inSceneNamed scene: String, withIdentifier identifier: String) {
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
}


extension Player: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // TODO later
    }
}
