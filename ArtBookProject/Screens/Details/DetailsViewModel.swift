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
    func didFilteringData(messega: String)
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
    
    func filteringData(id: UUID, selectedName : inout String, selectedArtist: inout String, selectedYear: inout String, selectedImage:UIImageView) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        let idString = id.uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String {
                    selectedName = name
                }
                if let artist = result.value(forKey: "artist") as? String {
                    selectedArtist = artist
                }
                if let year = result.value(forKey: "year") as? String {
                    selectedYear = year
                }
                if let imageData = result.value(forKey: "image") as? Data {
                    let image = UIImage(data: imageData)
                    selectedImage.image = image
                }
            }
        } catch {
            delegate?.didFilteringData(messega: error.localizedDescription)
        }
    }
}
