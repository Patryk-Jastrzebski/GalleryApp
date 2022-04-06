//
//  ContentView.swift
//  GalleryApp
//
//  Created by Patryk Jastrzębski on 24/03/2022.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    //Edit image variables
    @State private var bloomValue: Float = 0
    @State private var blurValue: Float = 0
    @State private var sepiaValue: Float = 0
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            
            if image != nil {
                VStack {
                image?
                    
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(30)
                    .scaleEffect(0.8)
                    .frame(width: 400, height: 400, alignment: .center)
                    
                    
                    VStack {
                        HStack(spacing: 20) {
                            Text("Bloom: ")
                                .foregroundColor(Color(.systemBlue))
                            Slider(value: $bloomValue, in: 0...1)
                                .onChange(of: bloomValue, perform: { value in applyFilters() }
                                )
                        }.padding()
                        
                        HStack(spacing: 20) {
                            Text("Rozmycie: ")
                                .foregroundColor(Color(.systemBlue))
                            Slider(value: $blurValue, in: 0...10)
                                .onChange(of: blurValue, perform: { value in applyFilters() }
                                )
                        }.padding()
                        
                        HStack(spacing: 20) {
                            Text("Sepia: ")
                                .foregroundColor(Color(.systemBlue))
                            Slider(value: $sepiaValue, in: 0...1)
                                .onChange(of: sepiaValue, perform: { value in applyFilters() }
                                )
                        }.padding()
                        
                    }
                }
            } else {
                Text("You have selected no image")
                
            }
            /*
             Image("TestImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .contrast(contrast)
                .cornerRadius(30)
                .padding()
                
            
            VStack {
                HStack(spacing: 20) {
                    Text("Kontrast: ")
                        .foregroundColor(Color(.systemBlue))
                    Slider(value: $contrast, in: 0.2...3)
                }.padding()
            }
            
            Spacer()*/

            Button(action: {
                UIImageWriteToSavedPhotosAlbum(processedImage!, nil, nil, nil)
            }) {
                Text("Zapisz")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .frame(width: 350, height: 60)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 10)
                    .padding()
            }
            
            
            
            Button(action: {
                self.showingImagePicker.toggle()
            }) {
                Text("Wybierz zdjęcie")
            }
            
            Spacer()
            
        }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
            ImagePicker(image: $inputImage)
        })
        
    }
    
    func applyFilters() {
        let context = CIContext()
        let blur = CIFilter.gaussianBlur()
        blur.inputImage = CIImage(image: inputImage!)
        blur.radius = blurValue
        
        let sepia = CIFilter.sepiaTone()
        sepia.inputImage = CIImage(image: inputImage!)
        sepia.intensity = sepiaValue
        
        let bloom = CIFilter.bloom()
        bloom.inputImage = CIImage(image: inputImage!)
        bloom.intensity = bloomValue
        
        sepia.setValue(blur.outputImage, forKey: "inputImage")
        bloom.setValue(sepia.outputImage, forKey: "inputImage")
        if let output = bloom.outputImage{
            if let cgimg = context.createCGImage(output, from: output.extent) {
                let processedUIImage = UIImage(cgImage: cgimg)
                image = Image(uiImage: processedUIImage)
                 processedImage = processedUIImage
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
            image = Image(uiImage: inputImage)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
















/*struct ImagePicker: UIViewControllerRepresentable {
    
    
    @Binding var image: UIImage?
    
    private let controller = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
*/
