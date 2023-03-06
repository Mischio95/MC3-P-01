//
//  Light.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 06/03/23.
//

import Foundation
import SpriteKit

class Light
{
    var lightSprite = SKSpriteNode()
    var _scale: CGFloat = 1.0
    var _screenH: CGFloat = 640.0
    var _screenW: CGFloat = 960.0
    var scene: SKScene!
    let light = SKLightNode()
    var ambientColor = UIColor.darkGray
    
    //MARK: Light
    func initLight(scene: SKScene) {
        lightSprite = SKSpriteNode(imageNamed: "lightbulb.png")
        lightSprite.setScale(_scale * 50)
        lightSprite.position = CGPoint(x: _screenW - 100, y: _screenH - 100)
        lightSprite.size = CGSize(width: 0.1, height: 0.1)
        scene.addChild(lightSprite)

        light.position = .zero
        light.falloff = 0.1
        light.ambientColor = ambientColor
        light.lightColor = .white
        
        // ADD OTHER LIFE FOR UPGRADE INTENSITY LIGHT
//        light2.position = .zero
//        light2.falloff = 1
//        light2.ambientColor = ambientColor
//        light2.lightColor = .red
        
        lightSprite.addChild(light)
    }

    func checkLightIsOnOff(player: Player)
    {
        if(player.lightIsOn)
        {
            self.lightSprite.position.y = player.sprite.position.y + 50
        }
        else
        {
            self.lightSprite.position.y = player.sprite.position.y + 3000

        }
    }

}



