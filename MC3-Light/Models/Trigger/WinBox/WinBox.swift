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
    var gate = Gate(sprite: SKSpriteNode(imageNamed: ""))


    override init(sprite: SKSpriteNode, size: CGSize)
    {
        super.init(sprite: sprite, size: size)
        self.sprite.name = "winBox"
//        self.sprite.size = CGSize(width: 100, height: 100)
        
        setup()
        startIdleAnimation()
    }

    func setGate(gate: Gate, position: CGPoint)
    {
        self.gate = gate
        self.gate.sprite.position = position
        self.gate.sprite.size = CGSize(width: 230, height: 230)
        self.gate.sprite.zPosition = self.sprite.zPosition
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
                    gate.startOpengateAnimation()
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
        return SKTextureAtlas(named: "LevettaAttivabile")
    }
    
    private var OpenAnimations: [SKTexture]
    {
        return[WinBoxAtlas.textureNamed("LevettaAttivabile1"),
               WinBoxAtlas.textureNamed("LevettaAttivabile2"),
               WinBoxAtlas.textureNamed("LevettaAttivabile3"),
               WinBoxAtlas.textureNamed("LevettaAttivabile4"),
               WinBoxAtlas.textureNamed("LevettaAttivabile5"),
               WinBoxAtlas.textureNamed("LevettaAttivabile6"),
               WinBoxAtlas.textureNamed("LevettaAttivabile7"),
               WinBoxAtlas.textureNamed("LevettaAttivabile8")]
    }
    
    private var IdleAnimations: [SKTexture]
    {
        return[WinBoxAtlas.textureNamed("LevettaAttivabile1")]
    }
    
    private var endAnimations: [SKTexture]
    {
        return[WinBoxAtlas.textureNamed("LevettaAttivabile8")]
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
