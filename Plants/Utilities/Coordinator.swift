//
//  Coordinator.swift
//  Plants
//
//  Created by Alex Daniel on 4/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isCoordinatorShown: Bool
    @Binding var image: SwiftUI.Image?
    @Binding var uiImage: UIImage?
    
    init(isShown: Binding<Bool>, image: Binding<SwiftUI.Image?>, uiImage: Binding<UIImage?>) {
        _isCoordinatorShown = isShown
        _image = image
        _uiImage = uiImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        image = SwiftUI.Image(uiImage: unwrapImage)
        uiImage = unwrapImage
        isCoordinatorShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
}

