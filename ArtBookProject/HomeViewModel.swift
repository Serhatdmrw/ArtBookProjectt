//
//  HomeViewModel.swift
//  ArtBookProject
//
//  Created by Serhat Demir on 3.04.2023.
//

import Foundation
import UIKit
import CoreData

protocol HomeViewModelDelegate:AnyObject {
    func didGetDataSuccess(nameArray : [String], idArray: [UUID])
    func didGetDataFail(messega : String)

    
}

class HomeViewModel {
    
    weak var delegate : HomeViewModelDelegate?
    
    var nameArray = [String]()
    var idArray = [UUID]()

    
    func getData() {
        
        nameArray.removeAll()
        idArray.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String {
                    nameArray.append(name)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    idArray.append(id)
                }
                delegate?.didGetDataSuccess(nameArray: nameArray, idArray: idArray)
            }
        } catch {
            delegate?.didGetDataFail(messega: error.localizedDescription)
        }
    }
}

