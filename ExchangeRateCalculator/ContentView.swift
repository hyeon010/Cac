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
        case home, exchageRate, calculation, record
    }

    var body: some View {
        TabView(selection: $selection) {
            HomeView(recordedItems: $recordedItems)
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            ExchageRateView(recordedItems: $recordedItems)
                .tabItem {
                    Label("환율", systemImage: "heart.fill")
                }
                .tag(Tab.exchageRate)

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
