import SwiftUI
import Mantis

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
        
        func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
            parent.image = cropped
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewControllerDidCancel(_ cropViewController: CropViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
