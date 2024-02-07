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
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Thefirstorecast")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to lad persistent storess: \(error)")
            }
        }
    }
    
    
    // Mapdata 생성하는 메서드
    func createMapData(lat: Double, lon: Double) {
        let context = persistentContainer.viewContext
        
        let mapData = MapData(context: context)
        mapData.lat = lat
        mapData.lon = lon
        
        do {
            try context.save()
            print("맵 데이터 생성이 성공적으로 진행")
        } catch {
            context.rollback()
            print("맵 데이터 생성 실패: \(error.localizedDescription)")
        }
        
    }
    
    // MapData 읽는 메서드
    func readMapData() -> [NSManagedObject] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MapData> = MapData.fetchRequest()
        
        do {
            let mapData = try context.fetch(fetchRequest)
            return mapData
        } catch {
            print("맵 데이터 로드 실패: \(error.localizedDescription)")
            return []
        }
    }
    
    // MapData 삭제 메서드
    func deleteMapData(at indexPath: IndexPath) {
        let context = persistentContainer.viewContext
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
}
