//
//  GameOver.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 25/02/23.
//

import SpriteKit

class GameOver: SKScene
{
    
    var soundToPlay = SKAudioNode()
    var soundName: String = ""
    
    var newGameButtonNode: SKSpriteNode!
    var objectAnimator = ObjectAnimator()
    
    override func didMove(to view: SKView) {
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
        gameOverControlFlag = true
        objectAnimator.setupAnimatorEndGameScene(scene: self)
        
        soundName = "EndGameGlitch"
        soundToPlay = SKAudioNode(fileNamed: self.soundName)
        soundToPlay.autoplayLooped = true
        soundToPlay.run(SKAction.changeVolume(by: Float(0.8), duration: 0))
        addChild(soundToPlay)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        let touch = touches.first
        
        if let location = touch?.location (in: self) {
            let nodesArray = self.nodes(at: location)
            if (nodesArray.first?.name == "newGameButton")
            {
                soundToPlay.removeFromParent()
                newGameButtonNode.alpha = 0.3
                let transition = SKTransition.fade(with: .black, duration: 0.2)
                let gameScene = SKScene(fileNamed: "GameScene") as! GameScene
                gameScene.scaleMode = .aspectFill

//                let gameScene = GameScene(size:self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }
}
