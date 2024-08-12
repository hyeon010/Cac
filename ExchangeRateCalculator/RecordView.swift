//
//  RecordView.swift
//  ExchangeRateCalculator
//
//  Created by 박상현 on 7/17/24.
//

import SwiftUI

struct RecordView: View {
    @Binding var recordedItems: [String]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recordedItems, id: \.self) { item in
                    Text(item)
                }
                .onDelete(perform: deleteItems)
            }
            .navigationBarTitle("계산 기록", displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        recordedItems.remove(atOffsets: offsets)
    }
}

struct RecordView_Previews: PreviewProvider {
    @State static var recordedItems: [String] = ["기록된 환율 결과 1", "기록된 환율 결과 2", "기록된 환율 결과 3"]
    
    static var previews: some View {
        RecordView(recordedItems: $recordedItems)
    }
}

