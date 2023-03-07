//
//  FloppyDisk.swift
//  MC3-Light
//
//  Created by Kiar on 27/02/23.
//

import Foundation
import SpriteKit

class FloppyDisk: Item
{
    var videoToPlay = SKVideoNode()
    var videoIsPlaying: Bool = false
    var floppyAnimator = FloppyAnimator()
    var videoName: String = ""
    
    init(videoName: String)
    {
        super .init(sprite: SKSpriteNode(imageNamed: "Floppy_disk"), size: CGSize(width: 50, height: 50), quantity: 1)
        self.sprite.name = "floppy"
        self.sprite.isHidden = false
        self.videoName = videoName
        self.quantity = quantity
        self.itemType = Utilities.ItemType.floppy
        setupPhyisics()
        floppyAnimator.startFloppyAnimation(sprite: self.sprite)
        videoToPlay = SKVideoNode(fileNamed: videoName)
        videoToPlay.zPosition = 100
    }
    
    override func setupPhyisics()
    {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width + 10, height: sprite.size.height + 10))
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.soundTriggerCategory
        sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        sprite.lightingBitMask = 1
    }
    
    func playFloppyVideo(scene: SKScene, player: Player, playerController: PlayerController)
    {
        player.canMove = false
        self.videoIsPlaying = true
        self.videoToPlay.play()
        player.videoFloppyIsPlaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 6)
        {
            self.stopFloppyVideo(player: player)
        }
        playerController.touchJump.texture = SKTexture(imageNamed: "Jump")
        
       
    }
    
    func stopFloppyVideo(player: Player)
    {
        videoIsPlaying = false
        self.videoToPlay.removeFromParent()
        sprite.removeFromParent()
        player.videoFloppyIsPlaying = false
        player.canMove = true
        player.canJump = true
        player.nearFloppy = false
    }
}
