//
//  Inventory.swift
//  MC3-Light
//
//  Created by Kiar on 04/03/23.
//

import Foundation

class PlayerInventory
{
    var playerInventory: [PickupItem] = []
    var boltAmount: Int = 0
    var keyAmount: Int = 0
    
}


//BOLT
extension PlayerInventory
{
    func addBoltsInInventory()
    {
        let quantity = Int.random(in: 1..<6)
        
        boltAmount += quantity
    }
}


//Key
extension PlayerInventory
{
    func addKey()
    {
        keyAmount += 1
    }
}


    //For multiple key
extension PlayerInventory
{
    func addItemInInventory(itemToAdd: PickupItem)
    {
        if(!itemToAdd.isStackable)
        {
            playerInventory.append(itemToAdd)
        }
        else
        {
            var itemIsInInventory: Bool = false
            //Controllo che l'elemento sia presente
            for index in 0..<playerInventory.count
            {
                if(playerInventory[index].GUID == itemToAdd.GUID)
                {
                    playerInventory[index].quantity += 1
                    itemIsInInventory = true
                }
            }
            if(!itemIsInInventory)
            {
                playerInventory.append(itemToAdd)
            }
        }
        itemToAdd.sprite.removeFromParent()
        
        print("ho")
        print(playerInventory.count)
        print("elementi")
    }
    
    func removeItemInInventory(itemToRemove: PickupItem)
    {
        for index in 0..<playerInventory.count
        {
            if(playerInventory[index].GUID == itemToRemove.GUID)
            {
                playerInventory.remove(at: index)
            }
        }
    }
    
    func numberOfKey(pickupItem: PickupItem) -> Int
    {
        if(playerInventory.count > 0)
        {
            for index in 0..<playerInventory.count
            {
                if(playerInventory[index].GUID == pickupItem.GUID)
                {
                    return playerInventory[index].quantity
                   
                }
            }
        }
        return 0
    }
}
