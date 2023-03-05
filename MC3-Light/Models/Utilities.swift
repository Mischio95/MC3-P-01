//
//  Utilities.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 25/02/23.
//

import Foundation
import SwiftUI
import SpriteKit

var joystickButtonClicked = false
var animRunning = false
var gameOverControlFlag = false
var playerLightIsOnGlobal = false
var playerSpeed = CGPoint.zero

var chooseSound = true
var chooseVibration = true
 
var timerStopped = false

struct Utilities
{
    struct CollisionBitMask
    {
        static let playerCategory:UInt32 = 1
        static let enemyCategory:UInt32 = 2
        static let groundCategory:UInt32 = 3
        static let chargingBoxCategory:UInt32 = 4
        static let itemCatecory:UInt32 = 5
        static let winBoxCategory:UInt32 = 6
        static let enemyViewCategory:UInt32 = 7
        static let invisibleGroundCategory: UInt32 = 8
        static let floppyDiskCategory: UInt32 = 9
        static let soundTriggerCategory: UInt32 = 10
        static let pickupItemCategory: UInt32 = 11
        static let merchantCategory: UInt32 = 12
    }
    
    struct ZIndex
    {
        static let background: CGFloat = CGFloat(0)
        static let layer1: CGFloat = CGFloat(1)
        static let layer2: CGFloat = CGFloat(2)
        static let layer3: CGFloat = CGFloat(3)
        static let ground: CGFloat = CGFloat(4)
        static let sceneObject: CGFloat = CGFloat(5)
        static let enemy: CGFloat = CGFloat(6)
        static let player: CGFloat = CGFloat(7)
        static let layer8: CGFloat = CGFloat(8)
        static let layer9: CGFloat = CGFloat(9)
        static let layer10: CGFloat = CGFloat(10)
        static let HUD: CGFloat = CGFloat(100)
    }
    
    enum ItemType
    {
        case defaultItem
        case floppy
        case questItem
    }
}
