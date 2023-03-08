//
//  MainMenu.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 25/02/23.
//

import Foundation
import SpriteKit



class MainMenu: SKScene
{
    var soundToPlay = SKAudioNode()
    var soundName: String = ""
    
    var newGameButtonNode: SKSpriteNode!
    
    var objectAnimator = ObjectAnimator()
    
    override func didMove(to view: SKView) {
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
        
        soundName = "HorrorTension"
        soundToPlay = SKAudioNode(fileNamed: self.soundName)
        soundToPlay.autoplayLooped = true
        soundToPlay.run(SKAction.changeVolume(by: Float(0.8), duration: 0))
        addChild(soundToPlay)
        
        objectAnimator.setupAnimatorPlayerMainMenu(scene: self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        let touch = touches.first
        
        if let location = touch?.location (in: self) {
            let nodesArray = self.nodes(at: location)
            if (nodesArray.first?.name == "newGameButton")
            {
                if finishTutorial == false
                {
                    soundToPlay.removeFromParent()
                    newGameButtonNode.alpha = 0.3
                    let transition = SKTransition.fade(with: .black, duration: 0.2)
                    let gameScene = SKScene(fileNamed: "Tutorial") as! Tutorial
                    gameScene.scaleMode = .aspectFill

                    self.view?.presentScene(gameScene, transition: transition)
                }
                else
                {
                    soundToPlay.removeFromParent()
                    newGameButtonNode.alpha = 0.3
                    let transition = SKTransition.fade(with: .black, duration: 0.2)
                    let gameScene = SKScene(fileNamed: "GameScene") as! GameScene
                    gameScene.scaleMode = .aspectFill

                    self.view?.presentScene(gameScene, transition: transition)
                }
            }
        }
    }
}




