//
//  GameViewController.swift
//  The_Ruins
//
//  Created by mai nguyen on 1/3/22.
//

import UIKit
import QuartzCore
import SceneKit


enum GameState {
    case loading, playing
}
class GameViewController: UIViewController {

    var gameView:GameView {return view as! GameView}
    var mainScene:SCNScene!
    
    //general
    var gameState: GameState = .loading
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSence()
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
        mainScene = SCNScene(named: "art.scnassets/Scenes/Stage1.scn")
        gameView.scene = mainScene
        gameView.isPlaying = true
    }
    //MARK:- walls
    //MARK:- camera
    //MARK:- player
    //MARK:- touches + movement
    //MARK:- gameloop functions
    //MARK:- enemies


}
//MARK: extension
