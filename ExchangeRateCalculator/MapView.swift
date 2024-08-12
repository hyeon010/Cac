//
//  MapView.swift
//  ExchangeRateCalculator
//
//  Created by 박상현 on 7/28/24.
//

import SwiftUI
import MapKit
import CoreLocation


struct MapView: View {
    var body: some View {
        List(cafes) { cafe in
            NavigationLink(destination:
                MapDetailView(cafe: cafe)) {
                Text(cafe.title)
            }
        }
        .navigationTitle("Cafes")
    }
}

#Preview {
    MapView()
}
