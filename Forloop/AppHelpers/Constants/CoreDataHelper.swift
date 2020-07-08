//
//  CoreDataHelper.swift
//  RideApp
//
//  Created by Nakul Sharma on 31/05/19.
//  Copyright © 2018 TecOrb Technologies Pvt. Ltd. All rights reserved.
//

import UIKit
import CoreData

//class CoreDataHelper: NSObject {
//    static let sharedInstance = CoreDataHelper()
//    fileprivate override init() {}
//
//    func isCarCategoryAlreadyInDataBase(_ carCategory: CarCategory)-> Bool{
//        var result = false
//        var managedObjectContext : NSManagedObjectContext!
//        if #available(iOS 10.0, *) {
//            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        } else {
//            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
//        }
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
//
//        let entityDescription = NSEntityDescription.entity(forEntityName: "CarCategory", in: managedObjectContext)
//
//        fetchRequest.entity = entityDescription
//
//        do {
//            let stArray = try managedObjectContext.fetch(fetchRequest)
//            if stArray.count > 0{
//                for s in stArray{
//                    if let str = s as? NSManagedObject{
//                        if ((str.value(forKey: "id") as! String) == carCategory.ID) {
//                            result = true
//                            break;
//                        }
//                    }
//                }
//
//            }else{
//                result = false
//            }
//
//        } catch {
//            result = false
//        }
//
//        return result
//    }
//
//    func saveCarCategory(_ carCategory: CarCategory){
//        var managedObjectContext : NSManagedObjectContext!
//        if #available(iOS 10.0, *) {
//            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        } else {
//            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
//        }
//
//        let entityDescription = NSEntityDescription.entity(forEntityName: "CarCategory", in: managedObjectContext)
//        let newCat = NSManagedObject(entity: entityDescription!, insertInto: managedObjectContext)
//        newCat.setValue(carCategory.ID, forKey: "id")
//        newCat.setValue(carCategory.distance, forKey: "distance")
//        newCat.setValue(carCategory.categoryName, forKey: "category_name")
//        newCat.setValue("\(carCategory.baseFair)", forKey: "base_fair")
//        newCat.setValue("\(carCategory.baseMile)", forKey: "base_mile")
//        newCat.setValue("\(carCategory.pricePerMile)", forKey: "price_per_mile")
//        newCat.setValue(carCategory.time, forKey: "time")
//        newCat.setValue("\(carCategory.waitingPricePerMinute)", forKey: "waiting_price_per_min")
//        newCat.setValue("\(carCategory.nearestCarLongitude)", forKey: "nearest_car_longitude")
//        newCat.setValue("\(carCategory.nearestCarLatitude)", forKey: "nearest_car_latitude")
//
//        do {
//            try managedObjectContext.save()
//        } catch {
//            print_debug("Error in saving the Category")
//        }
//    }
//
//    func getAllCarCategoriesFromDataBase() -> [CarCategory]{
//        var catArray = [CarCategory]()
//        var managedObjectContext : NSManagedObjectContext!
//        if #available(iOS 10.0, *) {
//            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        } else {
//            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
//        }
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
//        let entityDescription = NSEntityDescription.entity(forEntityName: "CarCategory", in: managedObjectContext)
//        fetchRequest.entity = entityDescription
//
//
//        do {
//            let stArray = try managedObjectContext.fetch(fetchRequest)
//            if stArray.count > 0{
//                for s in stArray{
//                    if let strn = s as? NSManagedObject{
//                        let cat = CarCategory()
//                        if let _ID = strn.value(forKey: "id") as? String{
//                            cat.ID = _ID
//                        }
//                        catArray.append(cat)
//                    }
//                }
//            }
//        } catch {
//        }
//
//        return catArray.sorted { (l1, l2) -> Bool in
//            l1.categoryName < l2.categoryName
//        }
//
//        return catArray
//    }
//
//
//    func deleteCarCategoriesFromDataBase(category: CarCategory) -> Bool{
//        var result = true
//
//        var managedObjectContext : NSManagedObjectContext!
//        if #available(iOS 10.0, *) {
//            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        } else {
//            managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
//        }
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
//        let entityDescription = NSEntityDescription.entity(forEntityName: "CarCategory", in: managedObjectContext)
//        fetchRequest.entity = entityDescription
//
//
//        do {
//            var ctArray = try managedObjectContext.fetch(fetchRequest)
//            for i in 0..<ctArray.count{
//                if let cat = ctArray[i] as? NSManagedObject{
//                    if category.ID == (cat.value(forKey: "id") as!String){
//                        //ctArray.remove(at: i)
//                        managedObjectContext.delete(cat)
//                        do {
//                            try managedObjectContext.save()
//                        } catch {
//                            result = false
//                            print_debug("Error in saving the Category")
//                        }
//                    }
//                }
//            }
//        } catch {
//            result = false
//        }
//
//        return result
//        //return catArray
//    }
//
//}
