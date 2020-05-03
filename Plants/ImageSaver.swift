//
//  ImageSaver.swift
//  Plants
//
//  Created by Alex Daniel on 4/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import UIKit

class ImageSaver: NSObject {
    func save(image: UIImage) -> String? {
        guard let normalized = self.fixOrientation(image: image), let data = normalized.pngData() else {
            return nil
        }
        
        let uuid = UUID()
        let name = "\(uuid).png"
        let filename = self.getDocumentsDirectory().appendingPathComponent(name)
        try? data.write(to: filename)
        return name        
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        // handle error
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getImage(filename: String) -> UIImage? {
        let fileManager = FileManager()
        let imagePath = self.getDocumentsDirectory().appendingPathComponent(filename)
        if fileManager.fileExists(atPath: imagePath.path) {
            let image = UIImage(contentsOfFile: imagePath.path)
            return image
        }
        return nil
    }
    
    func fixOrientation(image: UIImage) -> UIImage? {
        if image.imageOrientation == UIImage.Orientation.up {
            return image
        }

        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}
