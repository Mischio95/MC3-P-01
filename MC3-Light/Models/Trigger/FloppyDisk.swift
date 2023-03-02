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
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width + 100, height: sprite.size.height + 100))
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.soundTriggerCategory
        sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        sprite.zPosition = 1
    }
    
    func playFloppyVideo()
    {
        self.videoIsPlaying = true
        self.videoToPlay.play()
        self.videoToPlay.zPosition = 1000
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
