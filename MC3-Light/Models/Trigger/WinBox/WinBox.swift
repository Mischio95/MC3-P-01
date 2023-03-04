//
//  WinBox.swift
//  MC3-Light
//
//  Created by Kiar on 04/03/23.
//

import Foundation
import SpriteKit

class WinBox: Trigger
{
var numberOfKey: Int = 0
let GUID: UUID = UUID()

    override init(sprite: SKSpriteNode, size: CGSize)
    {
        super.init(sprite: sprite, size: size)
        self.sprite.name = "winBox"
        setup()
    }

    func setNumberOkKey(numberOfKey: Int)
    {
        self.numberOfKey = numberOfKey
    }

    func openGate(player: Player)
    {
        var opened: Bool = false
        
        for index in 0..<player.inventory.playerInventory.count
        {
            if(player.inventory.playerInventory[index].GUID == self.GUID)
            {
                if(player.inventory.playerInventory[index].quantity == self.numberOfKey)
                {
                    print("OpenGate")
                    startOpengateAnimation()
                    opened = true
                }
                else
                {
                    print("non ne hai abbastanza")
                }
            }
        }
        if(!opened)
        {
            print("non hai la chiave")
        }
    }

//ANIMATION
    private var floppyAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "Floppy")
    }
    
    private var floppyAnimations: [SKTexture]
    {
        return[floppyAtlas.textureNamed("WinBox1"),
               floppyAtlas.textureNamed("WinBox2"),
               floppyAtlas.textureNamed("WinBox3"),
               floppyAtlas.textureNamed("WinBox4"),
               floppyAtlas.textureNamed("WinBox5")]
    }
        
    func startOpengateAnimation()
    {
        let move = SKAction.animate(with: floppyAnimations, timePerFrame: 0.14)
        self.sprite.run(move)
        self.sprite = SKSpriteNode(imageNamed: "WinBox5")
    }


}
