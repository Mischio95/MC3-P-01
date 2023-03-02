//
//  ObjectAnimator.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 28/02/23.
//

import Foundation
import SpriteKit

class ObjectAnimator
{
    //MARK: MAIN MENU
    var animationPlayerMainMenu: SKAction!
    var playerMainMenu: SKSpriteNode!
    
    //MARK: GAME OVER
    var endGameSceneNode: SKSpriteNode!
    var animationEndGameSceneNode: SKAction!
    
    var spriteToAnimate: SKSpriteNode!
    var animationAction: SKAction!
    var soundToPlay = SKAudioNode()
    var soundName: String = ""
    

    
    func setupAnimatorPlayerMainMenu(scene : SKScene)
    {
        playerMainMenu = (scene.childNode(withName: "PlayerAnimMainMenu") as? SKSpriteNode)!
        animationPlayerMainMenu = SKAction(named: "MainMenuPlayer")
        playerMainMenu.run(animationPlayerMainMenu)
        
    }
    
    func setupAnimatorEndGameScene(scene: SKScene)
    {
        endGameSceneNode = (scene.childNode(withName: "EndGameSceneNode") as? SKSpriteNode)!
        animationEndGameSceneNode = SKAction(named: "EndGame")
        endGameSceneNode.run(animationEndGameSceneNode)
    }
    
   

}

class WaterPipe: ObjectAnimator
{
    var isPlaying: Bool = false
    
    var soundTriggerIn = SoundTrigger(sprite: SKSpriteNode(imageNamed: "LevettaAttivabile1"), size: CGSize(width: 10, height: 10))
    var soundTriggerOut = SoundTrigger(sprite: SKSpriteNode(imageNamed: "LevettaAttivabile1"), size: CGSize(width: 10, height: 10))
    
    func setupAnimatorWaterFall(scene : SKScene, player : Player)
    {
        spriteToAnimate = (scene.childNode(withName: "tuboConAcqua") as? SKSpriteNode)!
        animationAction = SKAction(named: "AcquaDalTubo")
        spriteToAnimate.run(animationAction)
        
        soundName = "waterEffect"
        soundToPlay = SKAudioNode(fileNamed: self.soundName)
        soundToPlay.isPositional = false
        if let exit = scene.childNode(withName: "tuboConAcqua")
        {
            soundToPlay.position = exit.position
            soundToPlay.isPositional = true
            scene.listener = player.sprite
        }
        soundToPlay.run(SKAction.changeVolume(by: Float(0.5), duration: 0))
        
       
       
        soundTriggerIn.sprite.position.x = spriteToAnimate.position.x - 2000
        soundTriggerIn.sprite.position.y = spriteToAnimate.position.y - 100
        soundTriggerIn.sprite.zPosition = 100
        soundTriggerIn.sprite.size = CGSize(width: 30, height: 30)
        
        soundTriggerOut.sprite.position.x = spriteToAnimate.position.x + 2000
        soundTriggerOut.sprite.position.y = spriteToAnimate.position.y - 100
        soundTriggerOut.sprite.zPosition = 100
        soundTriggerOut.sprite.size = CGSize(width: 30, height: 30)
        scene.addChild(soundTriggerIn.sprite)
        scene.addChild(soundTriggerOut.sprite)
//        handlerPlaySound(scene: scene)
    }
    
    func handlerPlaySound(scene : SKScene)
    {
        if(!self.isPlaying)
        {
            isPlaying = true
            soundToPlay.run(SKAction.changeVolume(to: 0.08, duration: 0.1))
            soundToPlay.run(SKAction.play())
        }
        
        else
        {
            isPlaying = false
            soundToPlay.run(SKAction.stop())
        }
    }
}

 
