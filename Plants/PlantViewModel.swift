//
//  PlantViewModel.swift
//  Plants
//
//  Created by Alex Daniel on 4/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import CoreData
import SwiftUI

class PlantViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    
    var objects: [Plant] {
        return fetchedResultsController.fetchedObjects ?? []
    }
    
    var images: [UIImage] {
        return self.fetchImages()
    }
    
    private let fetchedResultsController: NSFetchedResultsController<Plant>
    
    override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<Plant>(entityName: "Plant")
        request.sortDescriptors = []
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        

        super.init()
        // Configure the view model to receive updates from Core Data.
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
    
    private func fetchImages() -> [UIImage] {
        let imageSaver = ImageSaver()
        
        return objects.compactMap { (plant) in
            guard let image = imageSaver.getImage(filename: plant.photo!) else {
                return nil
            }
            
            return image
        }
    }
}

