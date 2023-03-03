//
//  FloppyDisk.swift
//  MC3-Light
//
//  Created by Kiar on 27/02/23.
//

import Foundation
import SpriteKit

class FloppyDisk: Trigger
{
    var videoToPlay = SKVideoNode()
    var videoIsPlaying: Bool = false
    
    init(sprite: SKSpriteNode, size: CGSize, videoToPlay:SKVideoNode)
    {
        super .init(sprite: sprite, size: size)
        self.sprite.name = "floppy"
        self.sprite.isHidden = false
        self.videoToPlay = videoToPlay
        setup()
    }
    
    override func setup()
    {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width + 10, height: sprite.size.height + 10))
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.soundTriggerCategory
        sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        sprite.zPosition = 1
        sprite.lightingBitMask = 1
    }
    
    func playFloppyVideo(scene: SKScene, player: Player, playerController: PlayerController)
    {
        self.videoIsPlaying = true
        self.videoToPlay.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 6)
        {
            self.stopFloppyVideo()
        }
        
        player.canJump = true
        playerController.touchJump.texture = SKTexture(imageNamed: "Jump")
        player.nearFloppy = false
    }
    
    func stopFloppyVideo()
    {
        videoIsPlaying = false
        self.videoToPlay.removeFromParent()
        sprite.removeFromParent()
        
    }
}
