//
//  PlantViewModel.swift
//  Plants
//
//  Created by Alex Daniel on 4/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import CoreData
import SwiftUI
import Combine

struct WrappedPlant: Hashable {
    var plant: Plant
    var image: UIImage?
}

class PlantViewModel: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    
    @Published var items: [Plant] = []
    private let fetchedResultsPublisher = PassthroughSubject<[Plant], Never>()
    private var cancellable: AnyCancellable?
    private let fetchedResultsController: NSFetchedResultsController<Plant>
    private var imageHash: [String: UIImage] = [:]

    var objects: [Plant] {
        return fetchedResultsController.fetchedObjects ?? []
    }
    
    override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = Plant.createFetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
        super.init()
        
        self.cancellable = fetchedResultsPublisher.map { (plants) -> [Plant] in
            let hash = self.primeImageCache(plants: plants)
            return plants.map { plant in
                if let photo = plant.photo, let image = hash[photo] {
                    plant.uiImage = image
                }                
                return plant
            }
        }.assign(to: \.items, on: self)

        // Configure the view model to receive updates from Core Data.
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        fetchedResultsPublisher.send(fetchedResultsController.fetchedObjects ?? [])
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchedResultsPublisher.send(fetchedResultsController.fetchedObjects ?? [])
    }
    
    private func primeImageCache(plants: [Plant]) -> [String: UIImage] {
        let imageSaver = ImageSaver()
        
        return plants.reduce(into: self.imageHash) {
            guard let photo = $1.photo, $0[photo] == nil, let image = imageSaver.getImage(filename: photo) else {
                return
            }
            $0[photo] = image
        }
    }
}

