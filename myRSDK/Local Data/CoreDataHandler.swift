//
//  CoreDataHandler.swift
//  Prego
//
//  Created by owner on 9/22/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class CoreDaTaHandler: NSObject {
    
    public static let shared = CoreDaTaHandler()
    let identifier: String  = "com.otherlogic.myRSDK"
    let model: String       = "Model"
    
    lazy var persistentContainer: NSPersistentContainer = {
            let messageKitBundle = Bundle(identifier: self.identifier)
            let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
            let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
            
            let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
            container.loadPersistentStores { (storeDescription, error) in
                
                if let err = error{
                    fatalError("❌ Loading of store failed:\(err)")
                }
            }
            
            return container
    }()

    private class func getContext() -> NSManagedObjectContext? {
        //let appDelegate = UIApplication.shared.delegate as! //AppDelegate
        //return appDelegate.persistentContainer.viewContext
        //return nil
        return CoreDaTaHandler.shared.persistentContainer.viewContext
    }
    
    class func saveCart(itemID:String, image: String, title: String, specialRequest: String, desc:String, quantity:Int32, totalPrice:Double, infoId: String, optionsIds: String, extraIds: String, offer: Bool, couponOffer: Bool, mDate:String) ->Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context!)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(itemID, forKey: "item_id")
        managedObject.setValue(image, forKey: "image")
        managedObject.setValue(desc, forKey: "desc")
        managedObject.setValue(quantity, forKey: "quantity")
        managedObject.setValue(title, forKey: "title")
        managedObject.setValue(specialRequest, forKey: "special_request")
        managedObject.setValue(totalPrice, forKey: "total_price")
        
        managedObject.setValue(infoId, forKey: "info_id")
        managedObject.setValue(extraIds, forKey: "extra_ids")
        managedObject.setValue(optionsIds, forKey: "options_ids")
        
        managedObject.setValue(offer, forKey: "offer")
        managedObject.setValue(couponOffer, forKey: "coupon_offer")
        
        
        managedObject.setValue(mDate, forKey: "mDate")
        
        do {
            try context!.save()
            return true
        }catch{
            return false
        }
    }
    
    class func saveCart(areaID: String, resID: String,itemID:String, image: String, title: String, specialRequest: String, desc:String, quantity:Int32, itemPrice:Double, optionPrice:Double, extraPrice:Double, totalPrice:Double, infoId: String, optionsIds: String, extraIds: String, offer: Bool, couponOffer: Bool, mDate:String) ->Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context!)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(areaID, forKey: "area_id")
        managedObject.setValue(resID, forKey: "res_id")
        managedObject.setValue(itemID, forKey: "item_id")
        managedObject.setValue(image, forKey: "image")
        managedObject.setValue(desc, forKey: "desc")
        managedObject.setValue(quantity, forKey: "quantity")
        managedObject.setValue(title, forKey: "title")
        managedObject.setValue(specialRequest, forKey: "special_request")
        
        managedObject.setValue(itemPrice, forKey: "price_item")
        managedObject.setValue(optionPrice, forKey: "price_option")
        managedObject.setValue(extraPrice, forKey: "price_extra")
        managedObject.setValue(totalPrice, forKey: "total_price")
        
        managedObject.setValue(infoId, forKey: "info_id")
        managedObject.setValue(extraIds, forKey: "extra_ids")
        managedObject.setValue(optionsIds, forKey: "options_ids")
        
        managedObject.setValue(offer, forKey: "offer")
        managedObject.setValue(couponOffer, forKey: "coupon_offer")
        
        managedObject.setValue(mDate, forKey: "mDate")
        do {
            try context!.save()
            return true
        }catch{
            return false
        }
    }

    class func getCarts() -> [Cart]? {
        let context = getContext()
        var items:[Cart]? = nil
        do {
            items = try context!.fetch(Cart.fetchRequest()) as? [Cart]
            return items
        }catch{
            return items
        }
    }
    
    class func deleteObject(id: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let predicate = NSPredicate(format: "mDate == %@", id as CVarArg)
        fetchRequest.predicate = predicate
        let context = getContext()
        let result = try? context!.fetch(fetchRequest)
        let resultData = result as! [Cart]
        
        for object in resultData {
            context!.delete(object)
        }
        
        do {
            try context!.save()
            return true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
    }
    
    class func updateCart(mDate: String, quantity: Int32, cart: Cart) -> Bool {

        
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "mDate = %@", mDate as CVarArg)
        do
        {
            let test = try managedContext!.fetch(fetchRequest)
            
            let managedObject = test[0] as! NSManagedObject
            managedObject.setValue(quantity, forKey: "quantity")
            managedObject.setValue(mDate, forKey: "mDate")
            do{
                try managedContext!.save()
                return true
            }
            catch{
                return false
            }
        }catch{
            return false
        }
    }
    
    class func updateCartPrice(mDate: String, itemPrice: Int32, optionPrice: Int32, extraPrice: Int32, areaID: String ,cart: Cart) -> Bool {

        
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.predicate = NSPredicate(format: "mDate = %@", mDate as CVarArg)
        do
        {
            let test = try managedContext!.fetch(fetchRequest)
            
            let managedObject = test[0] as! NSManagedObject
            managedObject.setValue(areaID, forKey: "area_id")
            managedObject.setValue(itemPrice, forKey: "price_item")
            //managedObject.setValue(optionPrice, forKey: "price_option")
            //managedObject.setValue(extraPrice, forKey: "price_extra")
            do{
                try managedContext!.save()
                return true
            }
            catch{
                return false
            }
        }catch{
            return false
        }
        
    }
    
    class func cleanData() ->Bool {
        let context = getContext()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Cart.fetchRequest())
        do {
            try context!.execute(deleteRequest)
            return true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
    }
}
