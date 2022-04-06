//
//  HomeViewModel.swift
//  GalleryApp
//
//  Created by Patryk Jastrzębski on 24/03/2022.
//

import SwiftUI

class HomeViewModel : ObservableObject {
    @Published var imagePicker = false
    @Published var imageData = Data(count: 0)
}
