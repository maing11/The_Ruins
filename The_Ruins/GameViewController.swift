//
//  GameViewController.swift
//  The_Ruins
//
//  Created by mai nguyen on 1/3/22.
//

import UIKit
import SceneKit


enum GameState {
    case loading, playing
}
class GameViewController: UIViewController {

    var gameView:GameView {return view as! GameView}
    var mainScene:SCNScene!
    
    //general
    var gameState: GameState = .loading
    
    //nodes
    private var player: Player?
    private var cameraStick:SCNNode!
    private var cameraXHolder: SCNNode!
    private var cameraYHolder: SCNNode!
    
    //movement
    private var controllerStoreDirection = float2(0.0)
    private var padTouch: UITouch?
    private var cameraTouch: UITouch?
    
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSence()
        setupPlayer()
        setUpCamera()
        gameState = .playing
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    //MARK:- scence
    
    private func setupSence() {
        gameView.allowsCameraControl = true
        gameView.antialiasingMode = .multisampling4X
        gameView.delegate = self

        
        mainScene = SCNScene(named: "art.scnassets/Scenes/Stage1.scn")
        gameView.scene = mainScene
        gameView.isPlaying = true
    }
    //MARK:- walls
    //MARK:- camera
    private func setUpCamera() {
        cameraStick = mainScene.rootNode.childNode(withName: "CameraStick", recursively: false)!
        cameraXHolder = mainScene.rootNode.childNode(withName: "xHolder", recursively: true)!

        cameraYHolder = mainScene.rootNode.childNode(withName: "yHolder", recursively: true)!

    }
    
    
    private func panCamera(_ direction: float2){
        var directionToPan = direction
        directionToPan *= float2(1.0, -1.0)
        
        let panReducer = Float(0.005)
        
        let currX = cameraYHolder.rotation
        let xRotationValue = currX.w - directionToPan.x * panReducer
        
        let currY = cameraYHolder.rotation
        var yRotationValue = currY.w - directionToPan.y * panReducer
        
        if yRotationValue < -0.94 {yRotationValue = -0.94}
        if yRotationValue > 0.66 {yRotationValue = 0.66}

        
        cameraXHolder.rotation = SCNVector4Make(0, 1, 0, xRotationValue)
        cameraYHolder.rotation = SCNVector4Make(1, 0, 0, yRotationValue)

        
    }
    
    //MARK:- player
    private func setupPlayer() {
        player = Player()
        player!.scale = SCNVector3Make(0.0026, 0.0026, 0.0026)
        player!.position = SCNVector3Make(0.0, 0.0, 0.0)
        player!.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        
        mainScene.rootNode.addChildNode(player!)


    }
    
    //MARK:- touches + movement
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if gameView.virtualAttackButton().contains(touch.location(in: gameView)) {
                if padTouch == nil {
                    padTouch = touch
                    controllerStoreDirection = float2(0.0)
                } else if cameraTouch == nil {
                    cameraTouch = touches.first
                }
            }
            if padTouch != nil {break}
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = padTouch {
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))
            
            let vMix = mix(controllerStoreDirection,displacement,t: 0.1)
            let vClamp = clamp(vMix, min: -1.0, max: 1.0)
            
            controllerStoreDirection = vClamp
            print(controllerStoreDirection)
        } else if let touch = cameraTouch {
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))
            panCamera(displacement)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        padTouch = nil
        controllerStoreDirection = float2(0.0)
        cameraTouch = nil
    }
  
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        padTouch = nil
        controllerStoreDirection = float2(0.0)
        cameraTouch = nil

    }
    
    private func CharacterDirection() -> float3 {
        var direction = float3(controllerStoreDirection.x, 0.0, controllerStoreDirection.y)
        
        if let pov = gameView.pointOfView {
            
            let p1 = pov.presentation.convertPosition(SCNVector3(direction), to: nil)
            let p0 = pov.presentation.convertPosition(SCNVector3Zero, to: nil)
            
            direction = float3(Float(p1.x - p0.x), 0.0, Float(p1.z - p0.z))
            
            if direction.x != 0.0 || direction.z != 0.0 {
                direction = normalize(direction)
            }

        }
        return direction
    }
    //MARK:- gameloop functions
    //MARK:- enemies


}
//MARK: extension


extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if gameState != .playing {return}
        
        let scene = gameView.scene!
        let direction = CharacterDirection()
        
        player!.walkIndirection(direction, time: time, scene: scene)
    }
}
