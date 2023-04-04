//
//  DetailsViewModel.swift
//  ArtBookProject
//
//  Created by Serhat Demir on 3.04.2023.
//

import Foundation
import UIKit
import CoreData

protocol DetailsViewModelDelegate:AnyObject {
    func didSaveDataFail(messega: String)
}

class DetailsViewModel {
    
    // MARK: - Delegate
    weak var delegate : DetailsViewModelDelegate?
    
    func saveData(name: String, artist: String, year: String, image: UIImageView) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPaintings = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        newPaintings.setValue(name, forKey: "name")
        newPaintings.setValue(artist, forKey: "artist")
        newPaintings.setValue(year, forKey: "year")
        if let data = image.image!.jpegData(compressionQuality: 0.5) {
            newPaintings.setValue(data, forKey: "image")
        }
        newPaintings.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()            
        } catch {
            delegate?.didSaveDataFail(messega: error.localizedDescription)
        }
    }
}
