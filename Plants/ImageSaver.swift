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
        if let data = image.pngData() {
            let uuid = UUID()
            let name = "\(uuid).png"
            let filename = self.getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
            return name
        }
        return nil
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
}
