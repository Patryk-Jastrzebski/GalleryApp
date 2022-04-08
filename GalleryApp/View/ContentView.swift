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
    
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            edit
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

var edit: some View {
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
        
        Button(action: {
            print("done")
            guard let processedImage = self.processedImage else {return}
            
            let imageSaver = ImageSaver()
            
            imageSaver.successHandler = {
                showingSuccessAlert.toggle()
            }
            
            imageSaver.writeToPhotoAlbum(image: processedImage)
            
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
        .alert("Zdjęcie zapisane pomyślnie", isPresented: $showingSuccessAlert) {Button("OK", role: .cancel) { }}
        
        Button(action: {
            self.showingImagePicker.toggle()
        }) {
            Text("Wybierz zdjęcie")
        }
        
        Spacer()
        
    }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
        ImagePicker(image: $inputImage)
    })
        .navigationBarHidden(true)
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
