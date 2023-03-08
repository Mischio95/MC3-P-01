//
//  SetupMap.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 02/03/23.
//

import Foundation
import SpriteKit

class SetupMap
{
    var bolt: SKSpriteNode!
    var background: SKSpriteNode!
    var ground: SKSpriteNode!
    var invisibleGround: SKSpriteNode!
    var allBackgrounds: [SKSpriteNode] = []
    
    //MARK: - setup BACKGROUND
    func setupBackground(scene: SKScene, nameBackground: String)
    {
        background = (scene.childNode(withName: nameBackground) as? SKSpriteNode)
        background.lightingBitMask = 1
        background.color = .darkGray
        background.colorBlendFactor = 1
        background.zPosition = Utilities.ZIndex.background
        background.anchorPoint = CGPoint(x:0.5, y:0.5)
        background.zPosition = -100
    }
    
    //MARK: - setup GROUND
    func setupGround(scene: SKScene, nameGround: String)
    {
        ground = (scene.childNode(withName: nameGround) as? SKSpriteNode)
        let groundBoxCollision = CGSize(width: ground!.size.width, height: ground.size.height-50)
        ground.physicsBody = SKPhysicsBody(rectangleOf: groundBoxCollision)
        ground.name = "ground"
        ground.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.groundCategory
        ground.physicsBody?.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        ground.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        ground.physicsBody?.isDynamic = false
        ground.lightingBitMask = 1
        ground.color = .black
        ground.zPosition = Utilities.ZIndex.ground
    }
    
    //MARK: - setup MURO INVISIBILE PER PERDERE QUANDO CADI
    func setupInvisibleGroundForFalling(scene: SKScene, nameGround: String)
    {
        invisibleGround = (scene.childNode(withName: nameGround) as? SKSpriteNode)
        invisibleGround.name = "invisibleGroundFalling"
        invisibleGround.physicsBody!.categoryBitMask = Utilities.CollisionBitMask.invisibleGroundCategory
        invisibleGround.physicsBody!.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        invisibleGround.physicsBody?.affectedByGravity = false
        invisibleGround.alpha = 0
        invisibleGround.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
    }
    
    func setupBolt(scene: SKScene, nameBackground: String, boltPick: Bolt)
    {
        bolt = (scene.childNode(withName: nameBackground) as? SKSpriteNode)
        bolt.lightingBitMask = 1
        bolt.isHidden = true
    }
}
