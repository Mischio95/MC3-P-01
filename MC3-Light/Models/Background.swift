//
//  Background.swift
//  MC3-Light
//
//  Created by Kiar on 28/02/23.
//

import Foundation
import SpriteKit

struct GameBackground
{
    var background: SKSpriteNode = SKSpriteNode()
    var allBackgrounds: [SKSpriteNode] = []
    var backgroundName: String = ""
    
    
    mutating func setupTempBackground(scene: SKScene)
    {
        print("Entro")
        var background1 = SKSpriteNode()
        background1 = scene.childNode(withName: "Sfondo") as! SKSpriteNode
        background1.lightingBitMask = 1
        background1.color = .darkGray
        background1.colorBlendFactor = 1
        background1.zPosition = -1
        background1.anchorPoint = CGPoint(x:0.5, y:0.5)
        background1.setScale(CGFloat(1) * 2)
        background1.zPosition = -100
//        allBackgrounds.append(background1)
        print("Esco")
    }
    
    
    
    mutating func createBackgroundsArray(scene: GameScene)
    {
        setupTempBackground(scene: scene)
//        setupBackgroundElements()
//        background.children.forEach{(background) in scene.childNode(withName: "Sfondo") as? SKSpriteNode?
//
//        allBackgrounds.append((scene.childNode(withName: "Sfondo") as? SKSpriteNode)!)
//        setupBackgroundElements()
            
    }
    func setupBackgroundElements()
    {
        for index in 0..<allBackgrounds.count
        {
            allBackgrounds[index].lightingBitMask = 1
            allBackgrounds[index].color = .darkGray
            allBackgrounds[index].colorBlendFactor = 1
            allBackgrounds[index].zPosition = -1
            allBackgrounds[index].anchorPoint = CGPoint(x:0.5, y:0.5)
            allBackgrounds[index].setScale(CGFloat(1) * 2)
            allBackgrounds[index].zPosition = -100
            print("Ciao")
        }
    }
}
