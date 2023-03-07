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
    var videoName: [String] = []
    var currentvideo: Int = 0
    var backgroundVideoImage = SKSpriteNode(imageNamed: "sfondoVideo")
    
    init(videoName: [String])
    {
        super .init(sprite: SKSpriteNode(imageNamed: "Floppy_disk"), size: CGSize(width: 50, height: 50), quantity: 1)
        self.sprite.name = "floppy"
        self.sprite.isHidden = false
        self.videoName = videoName
        self.quantity = quantity
        self.itemType = Utilities.ItemType.floppy
        setupPhyisics()
        self.floppyAnimator.startFloppyAnimation(sprite: self.sprite)
        self.videoToPlay.size = CGSize(width: 1200, height: 900)
        self.backgroundVideoImage.zPosition = Utilities.ZIndex.backgroundVideo
        
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
        if(player.videoPlay.currentvideo == 0)
        {
            player.videoPlay.sprite.addChild(player.videoPlay.backgroundVideoImage)
        }
        player.canMove = false
        self.videoIsPlaying = true
        player.videoPlay = self
        self.videoToPlay = SKVideoNode(fileNamed: self.videoName[currentvideo])
        self.videoToPlay.zPosition = Utilities.ZIndex.videoFloppy
        self.videoToPlay.size = CGSize(width: 1340, height: 610)
        self.videoToPlay.position = player.sprite.position
        scene.addChild(videoToPlay)
        self.videoToPlay.play()
        player.videoFloppyIsPlaying = true
        print("Count")
        print(videoName.count)
    }
    
func stopFloppyVideo(player: Player, playerController: PlayerController)
    {
        player.videoPlay.videoIsPlaying = false
        self.sprite.removeFromParent()
        self.backgroundVideoImage.removeFromParent()
        player.videoFloppyIsPlaying = false
        player.canMove = true
        player.canJump = true
        player.nearFloppy = false
        playerController.touchJump.texture = SKTexture(imageNamed: "Jump")
    }
}

