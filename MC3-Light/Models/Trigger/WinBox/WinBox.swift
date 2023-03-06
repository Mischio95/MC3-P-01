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
    var opened: Bool = false

    init(numberOfKey: Int)
    {
        super.init(sprite: SKSpriteNode(imageNamed: "WinBox"), size: CGSize(width: 50, height: 50))
        self.sprite.name = "winBox"
//        self.sprite.size = CGSize(width: 100, height: 100)
        
        setup()
        startIdleAnimation()
    }

    func setGate(gate: Gate, position: CGPoint)
    {
        self.gate = gate
        
        let gateBoxCollision = CGSize(width: -200, height: 500)
        self.gate.sprite.physicsBody = SKPhysicsBody(rectangleOf: gateBoxCollision)
        self.gate.sprite.position = position
        self.gate.sprite.size = CGSize(width: 230, height: 230)
        self.gate.sprite.zPosition = self.sprite.zPosition
        self.gate.sprite.physicsBody?.isDynamic = false
        self.gate.sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.gateCategory
        self.gate.sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        self.gate.sprite.lightingBitMask = 1
        self.gate.sprite.name = "gate"
    }
    
    func setNumberOkKey(numberOfKey: Int)
    {
        self.numberOfKey = numberOfKey
    }

    func openGate()
    {
        startOpengateAnimation()
        gate.startOpengateAnimation()
        opened = true
    }
    
    func chekOpenGate(player: Player)
    {
        if(numberOfKey == 0)
        {
            openGate()
        }
        else
        {
            for index in 0..<player.inventory.playerInventory.count
            {
                if(player.inventory.playerInventory[index].GUID == self.GUID)
                {
                    if(player.inventory.playerInventory[index].quantity == self.numberOfKey)
                    {
                       openGate()
                    }
                    else
                    {
                        print("non ne hai abbastanza")
                    }
                }
            }
            if(!opened)// se il for non ha trovato la chiave non la hai
            {
                print("non hai la chiave")
            }
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
