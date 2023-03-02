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
    var videoToPlay: SKVideoNode
    var videoIsPlaying: Bool = false
    
    init(sprite: SKSpriteNode, size: CGSize, videoToPlay:SKVideoNode)
    {
        self.videoToPlay = videoToPlay
        super.init(sprite: sprite, size: size)
        setup()
    }
    
    override func setup() {
        sprite.name = "floppy"
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.floppyDiskCategory
        sprite.physicsBody?.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
    }
    
    func playFloppyVideo()
    {
        self.videoIsPlaying = true
        self.videoToPlay.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 6)
        {
            self.stopFloppyVideo()
        }
    }
    
    func stopFloppyVideo()
    {
        videoIsPlaying = false
        self.videoToPlay.removeFromParent()
    }
}