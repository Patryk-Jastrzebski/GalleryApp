//
//  NavigationBar.swift
//  GalleryApp
//
//  Created by Patryk Jastrzębski on 11/04/2022.
//
import Foundation
import SwiftUI

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        navigationBar.prefersLargeTitles = false
        navigationBar.tintColor = UIColor.white
    }
}

extension UIScrollView {
    func hideIndicators() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
}
