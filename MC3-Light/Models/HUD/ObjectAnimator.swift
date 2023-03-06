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
    
    var winGame: SKNode!
    var winGameAnimation: SKAction!
    
    var waterNode: SKSpriteNode!
    var wateAnimation: SKAction!
    
    var waterNodeCascata: SKSpriteNode!
    var waterCascataAnimation: SKAction!
    
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
    
    var gasNode: SKSpriteNode!
    var gasNodeAnimation: SKAction!
    
    var waterGreenNode: SKSpriteNode!
    var waterGreenNodeAnimation: SKAction!

    func setupAnimatorPlayerMainMenu(scene : SKScene)
    {
        playerMainMenu = (scene.childNode(withName: "PlayerAnimMainMenu") as? SKSpriteNode)!
        animationPlayerMainMenu = SKAction(named: "MainMenuPlayer")
        playerMainMenu.run(animationPlayerMainMenu)
        
    }
    
    func setupWinGameAnimation(scene : SKScene)
    {
        winGame = (scene.childNode(withName: "winGameNode"))
        winGameAnimation = SKAction(named: "WinGame")
        winGame.run(winGameAnimation)
        
    }
    
    func setupAnimatorEndGameScene(scene: SKScene)
    {
        endGameSceneNode = (scene.childNode(withName: "EndGameSceneNode") as? SKSpriteNode)!
        animationEndGameSceneNode = SKAction(named: "EndGame")
        endGameSceneNode.run(animationEndGameSceneNode)
    }
    
    func setupAnimatorGas(scene: SKScene, nodeNameInTheScene: String)
    {
        gasNode = (scene.childNode(withName: nodeNameInTheScene) as? SKSpriteNode)!
        gasNode.lightingBitMask = 1
        gasNodeAnimation = SKAction(named: "TuboConFumo")
        gasNode.run(gasNodeAnimation)
    }
    
    func setupAnimatorWaterGreen(scene: SKScene, nodeNameInTheScene: String)
    {
        waterGreenNode = (scene.childNode(withName: nodeNameInTheScene) as? SKSpriteNode)!
        waterGreenNode.lightingBitMask = 1
        waterGreenNodeAnimation = SKAction(named: "WaterGreen")
        waterGreenNode.run(waterGreenNodeAnimation)
    }
    
    func setupWater(scene: SKScene, nodeNameInTheScene: String)
    {
        waterNode = (scene.childNode(withName: nodeNameInTheScene) as? SKSpriteNode)!
        waterNode.lightingBitMask = 1
        wateAnimation = SKAction(named: "Water")
        waterNode.run(wateAnimation)
        waterNode.color = .black
    }
    
    func setupWaterCascata(scene: SKScene, nodeNameInTheScene: String)
    {
        waterNodeCascata = (scene.childNode(withName: nodeNameInTheScene) as? SKSpriteNode)!
        waterNodeCascata.lightingBitMask = 1
        waterCascataAnimation = SKAction(named: "WaterCascata")
        waterNodeCascata.run(waterCascataAnimation)
        waterNode.color = .black
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
        
        spriteToAnimate.color = .darkGray
        spriteToAnimate.lightingBitMask = 1
        
        soundTriggerIn.sprite.isHidden = true
        soundTriggerOut.sprite.isHidden = true
        
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

 
