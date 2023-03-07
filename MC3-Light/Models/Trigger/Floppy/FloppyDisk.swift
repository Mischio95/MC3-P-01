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
        self.videoToPlay.removeFromParent()
        player.canMove = false
        self.videoIsPlaying = true
        player.videoPlay = self.videoToPlay
        self.videoToPlay = SKVideoNode(fileNamed: self.videoName[currentvideo])
        self.videoToPlay.zPosition = Utilities.ZIndex.videoFloppy
        self.videoToPlay.size = CGSize(width: 1200, height: 900)
        self.videoToPlay.position = player.sprite.position
        scene.addChild(videoToPlay)
        self.videoToPlay.play()
        player.videoFloppyIsPlaying = true
        print("Count")
        print(videoName.count)
        DispatchQueue.main.asyncAfter(deadline: .now() + 20)
        {
            if(self.currentvideo < self.videoName.count - 1)
            {
                print("if")
//                self.videoName.remove(at: self.currentvideo)
                self.currentvideo += 1
                self.playFloppyVideo(scene: scene, player: player, playerController: playerController)
            }
            else
            {
                print("else")
                self.stopFloppyVideo(player: player)
            }
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
