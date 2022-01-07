//
//  Golem.swift
//  The_Ruins
//
//  Created by mai nguyen on 1/6/22.
//

import Foundation
import SceneKit

class Golem: SCNNode {

    //general
    var gameView: GameView!

    
    //nodes
    private let daeHolderNode = SCNNode()
    private var characterNode: SCNNode!
    private var enemy: Player!
    
    
    init(enymy: Player, view: GameView) {
        super.init()
        self.gameView = view
        self.gameView = view
        
        setupModelScene()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - scene
    private func  setupModelScene() {
        name = "Golem"
        
        let idleURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Enemies/Golem@Idle", withExtension: "dae")
        
        let idleScene = try! SCNScene(url: idleURL!, options: nil)
        
        for child in idleScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        
        addChildNode(daeHolderNode)
        characterNode = daeHolderNode.childNode(withName: "CATRigHub002", recursively: true)!
    }

}
