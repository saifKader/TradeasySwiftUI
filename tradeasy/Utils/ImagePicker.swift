import SwiftUI
import Mantis

struct ImagePickerWithCrop: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerWithCrop>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerWithCrop>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropViewControllerDelegate {
        func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
            parent.selectedImage = cropped
            cropViewController.dismiss(animated: true, completion: nil) // dismiss the crop view controller
        }

        func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            cropViewController.dismiss(animated: true, completion: nil) // dismiss the crop view controller
        }
        
        
                
           
        
        
        let parent: ImagePickerWithCrop
        
        init(_ parent: ImagePickerWithCrop) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let selectedImage = info[.originalImage] as? UIImage {
                
                let cropViewController = Mantis.cropViewController(image: selectedImage)
                cropViewController.delegate = self
                picker.present(cropViewController, animated: true, completion: nil)
                
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        
        
    }
}


struct CropView: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CropView>) -> CropViewController {
        let cropViewController = Mantis.cropViewController(image: image!)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: UIViewControllerRepresentableContext<CropView>) {
        // No need to update anything here
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, CropViewControllerDelegate {
        func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
            
        }
        
        func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            
        }
        
        var parent: CropView
        
        init(_ parent: CropView) {
            self.parent = parent
        }
        
     
    }
}



import PhotosUI

struct MultipleImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0 // Set to 0 for unlimited
        configuration.filter = .images // Only allow images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: MultipleImagePicker

        init(_ parent: MultipleImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            if self.parent.images == nil {
                                self.parent.images = [image]
                            } else {
                                self.parent.images?.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}

