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
//        self.sprite.size = CGSize(width: 100, height: 100)
        
        setup()
        startIdleAnimation()
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
//                    startEndAnimation()
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
    private var WinBoxAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "WinBox")
    }
    
    private var OpenAnimations: [SKTexture]
    {
        return[WinBoxAtlas.textureNamed("WinBox1"),
               WinBoxAtlas.textureNamed("WinBox2"),
               WinBoxAtlas.textureNamed("WinBox3"),
               WinBoxAtlas.textureNamed("WinBox4"),
               WinBoxAtlas.textureNamed("WinBox5")]
    }
    
    private var IdleAnimations: [SKTexture]
    {
        return[WinBoxAtlas.textureNamed("WinBox1")]
    }
    
    private var endAnimations: [SKTexture]
    {
        return[WinBoxAtlas.textureNamed("WinBox5")]
    }
        
    func startEndAnimation()
    {
        let move = SKAction.animate(with: endAnimations, timePerFrame: 0.14)
        self.sprite.run(move)
    }
    
    func startOpengateAnimation()
    {
        let move = SKAction.animate(with: OpenAnimations, timePerFrame: 0.14)
        self.sprite.run(move)
//        self.sprite = SKSpriteNode(imageNamed: "WinBox5")
    }
    
    func startIdleAnimation()
    {
        let move = SKAction.animate(with: IdleAnimations, timePerFrame: 0.14)
        self.sprite.run(move)
    }


}
