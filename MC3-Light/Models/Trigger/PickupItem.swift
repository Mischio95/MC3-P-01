//
//  PickupItem.swift
//  MC3-Light
//
//  Created by Kiar on 23/02/23.
//

import Foundation
import SpriteKit

class Item: Trigger
{

    override init(sprite: SKSpriteNode, size: CGSize)
    {
        super .init(sprite: sprite, size: size)
        self.sprite.name = "item"
        setup()
    }
}
