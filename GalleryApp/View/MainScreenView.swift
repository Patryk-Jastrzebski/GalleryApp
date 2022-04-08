//
//  MainScreenView.swift
//  GalleryApp
//
//  Created by Patryk Jastrzębski on 08/04/2022.
//

import SwiftUI

struct MainScreenView: View {
    var spacingValue: CGFloat
    var spacingBottomValue: CGFloat
    
    init() {
        let screenHeight = UIScreen.main.bounds.size.height
        
        if screenHeight < 800 {
            self.spacingValue = 15
            self.spacingBottomValue = 0
        } else {
            self.spacingValue = 30
            self.spacingBottomValue = 10
        }
    }
    
    var body: some View {
        NavigationView {
        VStack {
            Image("mainViewImage")
                .scaleEffect(0.13)
                .frame(width: 400, height: 500, alignment: .center)
                .cornerRadius(50)
                .position(x:193,y: 30)
                
            VStack(spacing: spacingValue) {
                HStack {
                    Image(systemName: "pencil")
                        .font(Font.system(.largeTitle))
                        .foregroundColor(Color.white)
                    VStack {
                    Text("Aż 10 różnych filtrów")
                        .font(Font.system(.title3))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: 270, alignment: .leading)
                    Text("Wszystkie filtry możesz edytować według uznania")
                            .foregroundColor(Color(#colorLiteral(red: 0.7536942959, green: 0.7538221478, blue: 0.7536774278, alpha: 1)))
                            .fontWeight(.medium)
                            .frame(width: 275, alignment: .leading)
                    }
                }
                
                HStack {
                    Image(systemName: "square.and.arrow.down")
                        .font(Font.system(.largeTitle))
                        .foregroundColor(Color.white)
                    VStack {
                    Text("Zapisz zdjęcie")
                        .font(Font.system(.title3))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: 270, alignment: .leading)
                    Text("Edytowane zdjęcie możesz zapisać w swojej galerii")
                            .foregroundColor(Color(#colorLiteral(red: 0.7536942959, green: 0.7538221478, blue: 0.7536774278, alpha: 1)))
                            .fontWeight(.medium)
                            .frame(width: 275, alignment: .leading)
                    }
                }
                
                HStack {
                    Image(systemName: "dollarsign.square")
                        .font(Font.system(.largeTitle))
                        .foregroundColor(Color.white)
                    VStack {
                    Text("Aplikacja jest darmowa")
                        .font(Font.system(.title3))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: 270, alignment: .leading)
                    Text("Każda funkcja aplikacji jest darmowa")
                            .foregroundColor(Color(#colorLiteral(red: 0.7536942959, green: 0.7538221478, blue: 0.7536774278, alpha: 1)))
                            .fontWeight(.medium)
                            .frame(width: 275, alignment: .leading)
                    }
                }
            }
            Spacer(minLength: spacingBottomValue)
            
            NavigationLink(destination: ContentView(), label: {
                HStack {
                    Image(systemName: "note.text.badge.plus")
                    Text("WYBIERZ ZDJĘCIE")
                        .fontWeight(.medium)
                        
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                    .background(Color(#colorLiteral(red: 0.8280410171, green: 0.8281806111, blue: 0.8280226588, alpha: 1)))
                    .cornerRadius(15)
                    .foregroundColor(Color.black)
            }).padding()
                
        }.background(Color(#colorLiteral(red: 0.1046530381, green: 0.1046782807, blue: 0.1046497002, alpha: 1)))
                
        }
        
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}


