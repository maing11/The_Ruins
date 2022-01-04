//
//  GameView.swift
//  The_Ruins
//
//  Created by mai nguyen on 1/3/22.
//

import SceneKit
import SpriteKit


class GameView: SCNView {
    private var skScene:SKScene!
    private let overlayNode = SKNode()
    private var dpadSprite:SKSpriteNode!
    private var attackButtonSprite:SKSpriteNode!
    private var hpBar: SKSpriteNode!
    private let hpBarMaxWidth: CGFloat = 150.0


    override  func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layout2DOverlay()
    }
    deinit {
        
    }
    
    //MARK:- overlay functions
    private func setup2DOverlay(){
        let w = bounds.size.width
        let h = bounds.size.height

        skScene = SKScene(size: CGSize(width: w, height: h))
        skScene.scaleMode = .resizeFill

        setupDpad(with: skScene)
        setupAttackButton(with: skScene)
        setupHpBar(with: skScene)
        
        skScene.addChild(overlayNode)
        overlayNode.position = CGPoint(x: 0.0, y: h)

        overlaySKScene = skScene
        skScene.isUserInteractionEnabled = false
    }

    private func layout2DOverlay() {
        overlayNode.position = CGPoint(x: 0.0, y: bounds.size.height)
    }
    //MARK:- internal functions
    //MARK:- D-Pad
    private func setupDpad(with scence: SKScene){
        dpadSprite = SKSpriteNode(imageNamed: "art.scnassets/Assets/dpad.png")
        dpadSprite.position =  CGPoint(x: 10.0, y: 10.0)
        dpadSprite.xScale = 1.0
        dpadSprite.yScale = 1.0
        dpadSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        dpadSprite.size = CGSize(width: 150.0, height: 150.0)
        scence.addChild(dpadSprite)
    }
    
    func virtualDPadBounds() -> CGRect {
        var virtualDPadBounds =  CGRect(x: 10.0, y: 10.0, width: 150.0, height: 150.0)
        
        virtualDPadBounds.origin.y = bounds.size.height - virtualDPadBounds.size.height + virtualDPadBounds.origin.y
        return virtualDPadBounds
    }
    //MARK:- attack Button
    private func setupAttackButton(with scene: SKScene) {
        attackButtonSprite = SKSpriteNode(imageNamed: "art.scnassets/Assets/attack1.png")
        attackButtonSprite.position = CGPoint(x: bounds.size.height - 110.0, y: 50)
        attackButtonSprite.xScale = 1.0
        attackButtonSprite.yScale = 1.0
        attackButtonSprite.size = CGSize(width: 60.0, height: 60.0)
        attackButtonSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        attackButtonSprite.name = "attackButton"
        scene.addChild(attackButtonSprite)
        
    }
    
    func virtualAttackButton() -> CGRect {
        var virtualAttackButtonBounds = CGRect(x: bounds.width - 110, y: 50, width: 60.0, height: 60.0)
        virtualAttackButtonBounds.origin.y = bounds.size.height - virtualAttackButtonBounds.origin.y
        
        return virtualAttackButtonBounds
    }
    
    //MARK:- HP bar
    private func setupHpBar(with scene:SKScene ) {
        hpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: hpBarMaxWidth, height: 20))
        hpBar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        hpBar.position = CGPoint(x: 15.0, y: bounds.width - 35.0)
        hpBar.xScale = 1.0
        hpBar.yScale = 1.0
        scene.addChild(hpBar)
    }
    
    
}
