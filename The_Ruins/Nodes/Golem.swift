//
//  Golem.swift
//  The_Ruins
//
//  Created by mai nguyen on 1/6/22.
//

import Foundation
import SceneKit



enum GolemAnimationType {
    case walk
    case attack1
    case dead
}
class Golem: SCNNode {

    //general
    var gameView: GameView!

    
    //nodes
    private let daeHolderNode = SCNNode()
    private var characterNode: SCNNode!
    private var enemy: Player!
    
    //animations
    private var walkAnimation = CAAnimation()
    private var deadAnimation = CAAnimation()
    private var attack1Animation = CAAnimation()

    // movement
    private var previousUpdateTime = TimeInterval(0.0)
    private let noticeDistance:Float = 1.4
    private let movementSpeedLimiter = Float(0.5)
    
    private var isWalking:Bool = false {
        didSet {
            if oldValue != isWalking {
                if isWalking {
                    addAnimation(walkAnimation, forKey: "walk")
                } else {
                    removeAnimation(forKey: "walk")
                }
            }
        }
    }

    init(enymy: Player, view: GameView) {
        super.init()
        self.gameView = view
        self.gameView = view
        
        setupModelScene()
        loadAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - scene
    private func  setupModelScene() {
        name = "Golem"
        
        let idleURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Enemies/Golem@Idle", withExtension: "dae")
        
        let idleScene = try! SCNScene(url: idleURL!, options: nil)
        
        
        // Load add the childs into daeHolderNode
        for child in idleScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        
        //add daeHolderNode as child of the golem node
        addChildNode(daeHolderNode)
        characterNode = daeHolderNode.childNode(withName: "CATRigHub002", recursively: true)!
    }
    
    private func loadAnimations(){
        loadAnimation(animationType: .walk, inSceneName: "art.scnassets/Scenes/Enemies/Golem@Flight", withIdentifier: "unnamed_animation__1")
        loadAnimation(animationType: .dead, inSceneName: "art.scnassets/Scenes/Enemies/Golem@Dead", withIdentifier: "Golem@Dead-1")
        loadAnimation(animationType: .attack1, inSceneName: "art.scnassets/Scenes/Enemies/Golem@Attack(1)", withIdentifier: "Golem@Attack(1)-1")
    }
    
    private func loadAnimation(animationType: GolemAnimationType, inSceneName scene: String, withIdentifier identifier: String) {
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
    func update(with time: TimeInterval, and scene: SCNScene) {
        guard let enemy = enemy else {return}
        
        //delta time
        if previousUpdateTime == 0.0 {previousUpdateTime = time}
        let deltaTime = Float(min(time - previousUpdateTime, 1.0/60.0))
        previousUpdateTime  = time
        
        //get distance
        let distance = GameUtils.distanceBetweenVectors(vector1: enemy.position, vector2: position)
        print(distance)
        
        if distance < noticeDistance && distance > 0.01 {
            //move
            let vResult = GameUtils.getCoordinatesNeededToMoveToReachNode(form: position, to: enemy.position)
            let vx = vResult.vX
            let vz = vResult.vZ
            let angle = vResult.vZ
            
            let characterSpeed = deltaTime * movementSpeedLimiter
            
            if vx != 0.0 && vz != 0.0 {
                position.x += vx.characterSpeed
                position.z += vz.characterSpeed
                
                isWalking = true

            }
            
        } else {
            isWalking = false
        }
    }
}

// Conform to CAAniamtion Delegate protocol
extension Golem: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let id = anim.value(forKey: "animationId") as? String else {return}
    }
    
}
