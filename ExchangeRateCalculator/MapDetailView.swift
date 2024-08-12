//
//  MapDetailView.swift
//  ExchangeRateCalculator
//
//  Created by 박상현 on 8/6/24.
//

import SwiftUI


struct MapDetailView: View {
    
    let cafe:Cafe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(cafe.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                
                Text(cafe.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Latitude: \(cafe.latitude)")
                    Text("Longitude: \(cafe.longitude)")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                
                HStack {
                    Spacer()
                    Link(destination: URL(string: cafe.urlStr)!) {
                        Text("Visit Website")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(cafe.title)
    }
}

#Preview {
    MapDetailView(cafe: cafes[0])
}
