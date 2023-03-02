//
//  Platform.swift
//  MC3-Light
//
//  Created by Kiar on 20/02/23.
//





import Foundation
import SpriteKit

class Platform {
    
    var sprite: SKSpriteNode
    var size: CGSize
    
    init(sprite: SKSpriteNode, size: CGSize) {
        self.sprite = sprite
        self.size = size
    }
    
    func setup()
    {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.physicsBody?.isDynamic = true
    }
    
//    func setup() {
//        print("this platform setup")
//        let wait: SKAction = SKAction.wait(forDuration: 3)
//        let runCode: SKAction = SKAction.run {
//            self.switchPhysics()
//        }
//        let seq: SKAction = SKAction.sequence([wait, runCode])
//        let repeatSeq: SKAction = SKAction.repeatForever(seq)
//        self.run(repeatSeq)
//    }
//
//    func switchPhysics() {
//        if(self.physicsBody == nil) {
//            self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
//            self.physicsBody?.isDynamic = false
//            self.physicsBody?.affectedByGravity = false
//            self.physicsBody?.allowsRotation = false
//        } else {
//            //if there is a physicsbody, get rid of it
//            self.physicsBody = nil
//        }
//    }
}
