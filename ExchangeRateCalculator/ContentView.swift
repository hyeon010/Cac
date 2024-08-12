//
//  ContentView.swift
//  ExchangeRateCalculator
//
//  Created by 박상현 on 7/17/24.
//
import SwiftUI
import MapKit

struct ContentView: View {
    @State private var selection: Tab = .home
    @State private var recordedItems: [String] = []
    @State private var searchQuery: String = ""
    @State private var annotations: [MKPointAnnotation] = []

    enum Tab {
        case home, mapview, calculation, record
    }

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            MapView()
                .tabItem {
                    Label("환전소", systemImage: "heart.fill")
                }
                .tag(Tab.mapview)

            CalculationView(recordedItems: $recordedItems)
                .tabItem {
                    Label("계산", systemImage: "plusminus.circle.fill")
                }
                .tag(Tab.calculation)
            
            RecordView(recordedItems: $recordedItems)
                .tabItem {
                    Label("기록", systemImage: "list.bullet")
                }
                .tag(Tab.record)
        }
    }
}

#Preview {
    ContentView()
}
