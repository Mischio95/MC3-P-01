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
    var floppyAnimator = FloppyAnimator()
    
    init(sprite: SKSpriteNode, size: CGSize, videoToPlay:SKVideoNode)
    {
        super .init(sprite: sprite, size: size)
        self.sprite.name = "floppy"
        self.sprite.isHidden = false
        self.videoToPlay = videoToPlay
        setup()
        floppyAnimator.startFloppyAnimation(floppy: self)
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
        player.canMove = false
        self.videoIsPlaying = true
        self.videoToPlay.play()
        player.videoFloppyIsPlaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5)
        {
            
            self.stopFloppyVideo(player: player)
        }
    }
    
    func stopFloppyVideo(player: Player)
    {
        videoIsPlaying = false
        self.videoToPlay.removeFromParent()
        sprite.removeFromParent()
        player.videoFloppyIsPlaying = false
        player.canMove = true
    }
}
