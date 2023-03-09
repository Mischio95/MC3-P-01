//
//  SceneManagerGameScene.swift
//  MC3-Light
//
//  Created by Kiar on 08/03/23.
//

import Foundation
import SpriteKit

class GameSceneManager
{
    var scene: SKScene
    
    //MARK: QUESTITEM
    var questItem1: PickupItem?
    var questItem2: PickupItem?
    var questItem3: PickupItem?
    
    var questItemSpownPoint: SKNode
    var questItemsRef: [PickupItem] = []
    
    var winBox = WinBox(numberOfKey: 3)
    
    //MARK: BOLTS
    var boltsRef: [Bolt] = []
    
    var bolt0: Bolt?
    var bolt1: Bolt?
    var bolt2: Bolt?
    var bolt3: Bolt?
    var bolt4: Bolt?
    var bolt5: Bolt?
    var bolt6: Bolt?
    var bolt7: Bolt?
    var bolt8: Bolt?
    var bolt9: Bolt?
    var bolt10: Bolt?
    var bolt11: Bolt?
    var bolt12: Bolt?
    var bolt13: Bolt?
    var bolt14: Bolt?
    
    var boltSpownPoint: SKNode
    
    
    init(scene: SKScene)
    {
        self.scene = scene
        self.questItemSpownPoint = self.scene.childNode(withName: "keySpown1")!
        self.boltSpownPoint = self.scene.childNode(withName: "bolt0")!
        setQuestItems()
        setBolts()
    }
    
}

//MARK: QUESTITEM FUNCTION
extension GameSceneManager
{
    func setQuestItems()
    {
        questItemSpownPoint = self.scene.childNode(withName: "keySpown1")!
        questItem1 = PickupItem(GUID: winBox.GUID)
        questItem1?.sprite.position = questItemSpownPoint.position
        questItem1?.sprite.name = "questItem1"
        self.scene.addChild(questItem1!.sprite)
        questItemSpownPoint.isHidden = true
        questItemsRef.append(questItem1!)

        questItemSpownPoint = self.scene.childNode(withName: "keySpown2")!
        questItem2 = PickupItem(GUID: winBox.GUID)
        questItem2?.sprite.position = questItemSpownPoint.position
        questItem2?.sprite.name = "questItem2"
        self.scene.addChild(questItem2!.sprite)
        questItemSpownPoint.isHidden = true
        questItemsRef.append(questItem2!)

        questItemSpownPoint = self.scene.childNode(withName: "keySpown3")!
        questItem3 = PickupItem(GUID: winBox.GUID)
        questItem3?.sprite.position = questItemSpownPoint.position
        questItem3?.sprite.name = "questItem3"
        self.scene.addChild(questItem3!.sprite)
        questItemSpownPoint.isHidden = true
        questItemsRef.append(questItem3!)
    }
    
    func toggleVisibilityQuestItems(lightIsOn: Bool)
    {
        if(!lightIsOn)
        {
            for index in 0..<questItemsRef.count
            {
                questItemsRef[index].sprite.removeFromParent()
            }
        }
        else
        {
            for index in 0..<questItemsRef.count
            {
                self.scene.addChild(questItemsRef[index].sprite)
            }
        }
    }
    
    func addItemInPlayerInventory(player: Player, nameOfItemToRemove: String)
    {
        var found: Bool = false
        var index: Int = 0
        
        while !found && index < self.questItemsRef.count
        {
            if(questItemsRef[index].sprite.name == nameOfItemToRemove)
            {
//                player.inventory.addItemInInventory(itemToAdd: questItemsRef[index])
                player.inventory.addKey()
                questItemsRef[index].sprite.removeFromParent()
                questItemsRef.remove(at: index)
                found = true
            }
            index += 1
        }
    }
}


//MARK: BOLTS
extension GameSceneManager
{
   func setBolts()
    {
        boltSpownPoint = self.scene.childNode(withName: "bolt0")!
        bolt0 = Bolt(quantity: Int.random(in: 0...5))
        bolt0?.sprite.position = boltSpownPoint.position
        bolt0?.sprite.name = "bolt0"
        self.scene.addChild(bolt0!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt0!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt1")!
        bolt1 = Bolt(quantity: Int.random(in: 0...5))
        bolt1?.sprite.position = boltSpownPoint.position
        bolt1?.sprite.name = "bolt1"
        self.scene.addChild(bolt1!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt1!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt2")!
        bolt2 = Bolt(quantity: Int.random(in: 0...5))
        bolt2?.sprite.position = boltSpownPoint.position
        bolt2?.sprite.name = "bolt2"
        self.scene.addChild(bolt2!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt2!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt3")!
        bolt3 = Bolt(quantity: Int.random(in: 0...5))
        bolt3?.sprite.position = boltSpownPoint.position
        bolt3?.sprite.name = "bolt3"
        self.scene.addChild(bolt3!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt3!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt4")!
        bolt4 = Bolt(quantity: Int.random(in: 0...5))
        bolt4?.sprite.position = boltSpownPoint.position
        bolt4?.sprite.name = "bolt4"
        self.scene.addChild(bolt4!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt4!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt5")!
        bolt5 = Bolt(quantity: Int.random(in: 0...5))
        bolt5?.sprite.position = boltSpownPoint.position
        bolt5?.sprite.name = "bolt5"
        self.scene.addChild(bolt5!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt5!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt6")!
        bolt6 = Bolt(quantity: Int.random(in: 0...5))
        bolt6?.sprite.position = boltSpownPoint.position
        bolt6?.sprite.name = "bolt6"
        self.scene.addChild(bolt6!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt6!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt7")!
        bolt7 = Bolt(quantity: Int.random(in: 0...5))
        bolt7?.sprite.position = boltSpownPoint.position
        bolt7?.sprite.name = "bolt7"
        self.scene.addChild(bolt7!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt7!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt8")!
        bolt8 = Bolt(quantity: Int.random(in: 0...5))
        bolt8?.sprite.position = boltSpownPoint.position
        bolt8?.sprite.name = "bolt8"
        self.scene.addChild(bolt8!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt8!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt9")!
        bolt9 = Bolt(quantity: Int.random(in: 0...5))
        bolt9?.sprite.position = boltSpownPoint.position
        bolt9?.sprite.name = "bolt9"
        self.scene.addChild(bolt9!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt9!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt10")!
        bolt10 = Bolt(quantity: Int.random(in: 0...5))
        bolt10?.sprite.position = boltSpownPoint.position
        bolt10?.sprite.name = "bolt10"
        self.scene.addChild(bolt10!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt10!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt11")!
        bolt11 = Bolt(quantity: Int.random(in: 0...5))
        bolt11?.sprite.position = boltSpownPoint.position
        bolt11?.sprite.name = "bolt11"
        self.scene.addChild(bolt11!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt11!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt12")!
        bolt12 = Bolt(quantity: Int.random(in: 0...5))
        bolt12?.sprite.position = boltSpownPoint.position
        bolt12?.sprite.name = "bolt12"
        self.scene.addChild(bolt12!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt12!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt13")!
        bolt13 = Bolt(quantity: Int.random(in: 0...5))
        bolt13?.sprite.position = boltSpownPoint.position
        bolt13?.sprite.name = "bolt13"
        self.scene.addChild(bolt13!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt13!)
        
        boltSpownPoint = self.scene.childNode(withName: "bolt14")!
        bolt14 = Bolt(quantity: Int.random(in: 0...5))
        bolt14?.sprite.position = boltSpownPoint.position
        bolt14?.sprite.name = "bolt14"
        self.scene.addChild(bolt14!.sprite)
        boltSpownPoint.isHidden = true
        boltsRef.append(bolt14!)
    }
}
