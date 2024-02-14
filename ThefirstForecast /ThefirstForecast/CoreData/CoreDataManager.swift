//
//
//  CoreDataManager.swift
//  ThefirstForecast
//
//  Created by t2023-m0044 on 2/6/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    // 싱글톤 패턴 적용
    static var shared = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    var context : NSManagedObjectContext {
        return self.persistentContainer!.viewContext
    }
    
    let request = MapData.fetchRequest()
    
    
    // Mapdata 생성하는 메서드
    func createMapData(lat: Double, lon: Double) {
        let newMapData = MapData(context: context)
        newMapData.lat = lat
        newMapData.lon = lon
        
        do {
            try context.save()
            print("맵 데이터 생성이 성공적으로 진행")
        } catch {
            context.rollback()
            print("맵 데이터 생성 실패: \(error.localizedDescription)")
        }
        
    }
    
    // MapData 읽는 메서드
    func readMapData() -> [MapData] {
        var mapData = [MapData]()
        do {
            let data = try context.fetch(request)
            mapData = data
        }catch{
            print("Error readdata :\(error)")
        }
        return mapData
    }
    
     
    func deleteMapData(at indexPath: IndexPath) {
        let mapData = readMapData()
        let dataToDelete = mapData[indexPath.row]
        context.delete(dataToDelete)
        
        do {
            try context.save()
            print("맵 데이터 삭제 성공")
        } catch {
            context.rollback()
            print("맵 데이터 삭제 실패: \(error.localizedDescription)")
        }
    }
    func deleteAllData() {
           let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MapData")
           
           do {
               let objects = try context.fetch(fetchRequest)
               for object in objects {
                   if let managedObject = object as? NSManagedObject {
                       context.delete(managedObject)
                   }
               }
               
               try context.save()
           } catch let error {
               print("Error deleting all data: \(error.localizedDescription)")
           }
       }
}
