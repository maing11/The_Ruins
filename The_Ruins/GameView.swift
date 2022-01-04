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
    //MARK:- attackButton
    
}
