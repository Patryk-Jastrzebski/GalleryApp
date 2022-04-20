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
    @State private var gammaValue: Float = 1
    @State private var vignetteValue: Float = -1
    @State private var sepiaValue: Float = 0
    @State private var crystalizeValue: Float = 1
    @State private var hueLevel: Float = 0
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var showingImagePicker = true
    @State private var editPageSelected = 0

    var body: some View {
        
        NavigationView {
            VStack {
                edit
                    .alert("Zdjęcie zapisane pomyślnie", isPresented: $showingSuccessAlert) {Button("OK", role: .cancel) { }}
                Spacer()
            }
        }
        .navigationTitle("Edycja")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    guard let processedImage = self.processedImage else {return}
                    
                    let imageSaver = ImageSaver()
                    
                    imageSaver.successHandler = {
                        showingSuccessAlert.toggle()
                    }
                    
                    imageSaver.writeToPhotoAlbum(image: processedImage)
                    
                }) {
                    Image(systemName: "square.and.arrow.down")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.showingImagePicker.toggle()
                }) {
                    Image(systemName: "photo.on.rectangle")
                }
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

var edit: some View {
   
    VStack {
        ZStack {
        if image != nil {
            VStack {
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer().frame(height:15, alignment: .center)
                
                    if editPageSelected == 0 {
                        Spacer(minLength: 30)
                            .frame(height: 60)
                    }
                
                    if editPageSelected == 1 {
                        HStack(spacing: 20) {
                            Text("Jasność: ")
                                .foregroundColor(Color(.systemBlue))
                            Slider(value: $gammaValue, in: 0.5...1.5)
                                .padding(5)
                                .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                                .cornerRadius(5)
                                .onChange(of: gammaValue, perform: { value in applyFilters() }
                                )
                        }.padding()
                    }
                    if editPageSelected == 2 {
                        HStack(spacing: 20) {
                            Text("Winieta: ")
                                .foregroundColor(Color(.systemBlue))
                            Slider(value: $vignetteValue, in: -1.0...2.0)
                                .padding(5)
                                .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                                .cornerRadius(5)
                                .onChange(of: vignetteValue, perform: { value in applyFilters() }
                                )
                        }.padding()
                    }
                    if editPageSelected == 3 {
                        HStack(spacing: 20) {
                            Text("Sepia: ")
                                .foregroundColor(Color(.systemBlue))
                            Slider(value: $sepiaValue, in: 0...1)
                                .padding(5)
                                .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                                .cornerRadius(5)
                                .onChange(of: sepiaValue, perform: { value in applyFilters() }
                                )
                        }.padding()
                    }
                    if editPageSelected == 4 {
                        HStack(spacing: 20) {
                            Text("Krystalizacja: ")
                                .foregroundColor(Color(.systemBlue))
                            Slider(value: $crystalizeValue, in: 1...50)
                                .padding(5)
                                .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                                .cornerRadius(5)
                                .onChange(of: crystalizeValue, perform: { value in applyFilters() }
                                )
                        }.padding()
                    }
                    if editPageSelected == 5 {
                        HStack(spacing: 20) {
                            Text("Kolor: ")
                                .foregroundColor(Color(.systemBlue))
                            Slider(value: $hueLevel, in: 0...7)
                                .padding(5)
                                .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                                .cornerRadius(5)
                                .onChange(of: hueLevel, perform: { value in applyFilters() }
                                )
                        }.padding()
                    }
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 10) {
                    
                        Button(action: {editPageSelected=1}, label: {Text("Jasność").foregroundColor(.secondary)})
                        Button(action: {editPageSelected=2}, label: {Text("Winieta").foregroundColor(.secondary)})
                        Button(action: {editPageSelected=3}, label: {Text("Sepia").foregroundColor(.secondary)})
                        Button(action: {editPageSelected=4}, label: {Text("Krystalizacja").foregroundColor(.secondary)})
                        Button(action: {editPageSelected=5}, label: {Text("Kolory").foregroundColor(.secondary)})
                    }}
                .padding(5)
                .background(Color(#colorLiteral(red: 0.2234891057, green: 0.2235331833, blue: 0.2234833241, alpha: 1)))
                .cornerRadius(5)
                .padding()
                    
                //.frame(width: .infinity, height: 30, alignment: .center)
            }
        } else {
            Text("Proszę wybrać zdjęcie 🥳")
                .font(.title3)
                .fontWeight(.medium)
                .fixedSize()
                .padding()
        }}
    }
    .sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
        ImagePicker(image: $inputImage)
    })
        .navigationBarBackButtonHidden(true)
    }
    
    // IMAGE FILTER FUNCTIONS
    
    func applyFilters() {
        let context = CIContext()
        //WINIETA
        let vignetteFilter = CIFilter.vignette()
        vignetteFilter.inputImage = CIImage(image: inputImage!)
        vignetteFilter.intensity = vignetteValue
        //SEPIA
        let sepia = CIFilter.sepiaTone()
        sepia.inputImage = CIImage(image: inputImage!)
        sepia.intensity = sepiaValue
        //NOISE
        let crystallizeFilter = CIFilter.crystallize()
        crystallizeFilter.inputImage = CIImage(image: inputImage!)
        crystallizeFilter.radius = crystalizeValue
        
        crystallizeFilter.center = CGPoint(x: inputImage!.size.width / 2, y: inputImage!.size.height / 2)
        
        //Hue
        let hue = CIFilter.hueAdjust()
        hue.inputImage = CIImage(image: inputImage!)
        hue.angle = hueLevel
        
        //GAMMA
        let gamma = CIFilter.gammaAdjust()
        gamma.inputImage = CIImage(image: inputImage!)
        gamma.power = gammaValue
        
        
        sepia.setValue(vignetteFilter.outputImage, forKey: "inputImage")
        crystallizeFilter.setValue(sepia.outputImage, forKey: "inputImage")
        hue.setValue(crystallizeFilter.outputImage, forKey: "inputImage")
        gamma.setValue(hue.outputImage, forKey: "inputImage")
        
        
        if let output = gamma.outputImage{
            if let cgimg = context.createCGImage(output, from: output.extent) {
                var processedUIImage: UIImage
                    processedUIImage = UIImage(cgImage: cgimg, scale: 1.0, orientation: UIImage.Orientation(rawValue: (inputImage?.imageOrientation)!.rawValue)!)
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
