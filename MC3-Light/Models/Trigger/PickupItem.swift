//
//  PickupItem.swift
//  MC3-Light
//
//  Created by Kiar on 23/02/23.
//

import Foundation
import SpriteKit

class Item
{
    var itemType: Utilities.ItemType = Utilities.ItemType.defaultItem
    var sprite: SKSpriteNode
    var size: CGSize
    var quantity: Int
    var isStackable: Bool = false
    
    init(sprite: SKSpriteNode, size: CGSize, quantity: Int)
    {
        self.sprite = sprite
        self.size = size
        self.sprite.size = size
        self.quantity = quantity
        self.sprite.name = "pickup"
//        self.sprite.zPosition = Utilities.ZIndex.sceneObject
        setupPhyisics()
    }
    
    func setupPhyisics()
    {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.pickupItemCategory
        sprite.physicsBody?.allowsRotation = false
        sprite.lightingBitMask = 1
    }
}


class PickupItem: Item
{
    var GUID: UUID = UUID()
    
    var floppyAnimator = FloppyAnimator()
    
    func setGUID(GUID: UUID)
    {
        self.GUID = GUID
    }
}
