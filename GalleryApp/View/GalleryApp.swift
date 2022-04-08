//
//  GalleryAppApp.swift
//  GalleryApp
//
//  Created by Patryk Jastrzębski on 24/03/2022.
//

import SwiftUI

@main
struct GalleryApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .preferredColorScheme(.dark)
        }
    }
}
