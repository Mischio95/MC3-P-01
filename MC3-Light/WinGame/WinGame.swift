//
//  WinGame.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 03/03/23.
//

import Foundation
import SpriteKit

class WinGame: SKScene
{
    var objectAnimator = ObjectAnimator()
    var newGameButtonNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        objectAnimator.setupWinGameAnimation(scene: self)
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        let touch = touches.first
        
        if let location = touch?.location (in: self) {
            let nodesArray = self.nodes(at: location)
            
            
            if finishTutorial == false
            {
                newGameButtonNode.alpha = 0.3
                let transition = SKTransition.fade(with: .black, duration: 0.2)
                let gameScene = SKScene(fileNamed: "Tutorial") as! Tutorial
                gameScene.scaleMode = .aspectFill

                self.view?.presentScene(gameScene, transition: transition)
            }
            
            else
            {
                newGameButtonNode.alpha = 0.3
                let transition = SKTransition.fade(with: .black, duration: 0.2)
                let gameScene = SKScene(fileNamed: "GameScene") as! GameScene
                gameScene.scaleMode = .aspectFill

                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }
}
