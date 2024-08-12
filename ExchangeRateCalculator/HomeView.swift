//
//  HomeView.swift
//  ExchangeRateCalculator
//
//  Created by 박상현 on 7/17/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        NavigationView {
        
            VStack {
                // 현재 날짜 표시
                Text("\(Date(), formatter: dateFormatter)")
                    .font(.subheadline)
                    .padding(.top, 10)
                
                
                // 환영 메시지
                Text("환율계산기")
                    .bold()
                    .font(.largeTitle)
                    .padding(.top, 50)
                
                // 앱 기능 안내
                Text("이 앱은 다양한 통화의 환율을 계산하고 기록할 수 있습니다.")
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                // 간단한 이미지나 아이콘
                Image(systemName: "arrow.2.circlepath")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 50)
                
                Spacer()
            }
            .navigationBarTitle("홈", displayMode: .inline)
        }
    }
}

// 날짜 형식 지정
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR") // 한국어 형식
    formatter.dateFormat = "yyyy년 MM월 dd일 EEEE" // 날짜 형식 설정
    return formatter
}()

#Preview {
    HomeView()
}


