//
//  Bolt.swift
//  MC3-Light
//
//  Created by Kiar on 05/03/23.
//

import Foundation
import SpriteKit

class Bolt: Item
{
    var amount: Int = 0
    
    init(quantity: Int)
   {
       super.init(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 35, height: 35), quantity: quantity)
       self.sprite.name = "bolt"
       setupPhyisics()
       startboltAnimation()
   }
    
    override func setupPhyisics() {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.gateCategory
        sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        sprite.lightingBitMask = 1
    }
}


//Bolt animation
extension Bolt
{
    private var boltAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "Bolts")
    }
    
    private var boltAnimation: [SKTexture]
    {
        return[boltAtlas.textureNamed("bolt1"),
               boltAtlas.textureNamed("bolt2"),
               boltAtlas.textureNamed("bolt3"),
               boltAtlas.textureNamed("bolt4"),
               boltAtlas.textureNamed("bolt5")]
    }
    
    func startboltAnimation()
    {
        let rotate = SKAction.animate(with: boltAnimation, timePerFrame: 0.09)
        self.sprite.run(SKAction.repeatForever(rotate), withKey: "boltAnimation")
    }
}
