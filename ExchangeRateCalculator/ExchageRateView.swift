//
//  ExchageRateView.swift
//  ExchangeRateCalculator
//
//  Created by 박상현 on 8/15/24.
//

import SwiftUI

struct ExchageRateView: View {
    @Binding var recordedItems: [String]

    @State private var exchangeRates: [ExchangeRate] = []
    @State private var searchText: String = ""
    
    var filteredExchangeRates: [ExchangeRate] {
        if searchText.isEmpty {
            return exchangeRates
        } else {
            return exchangeRates.filter { $0.curNm.contains(searchText) }
        }
    }
    
    var body: some View {
        
        VStack {
            // 검색 바 (고정됨)
            TextField("환율 정보를 원하는 나라를 검색하세요.", text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            // 오늘 날짜 표시
            Text("오늘 날짜: \(todayDate)")
                .font(.subheadline)
                .padding(.top, 5)
            
            // 리스트
            List(filteredExchangeRates, id: \.curUnit) { item in
                VStack(alignment: .leading) {
                    // curNm을 "아랍에미리트 디르함" -> "아랍에미리트 (디르함)"으로 변환
                    Text(formatCurrencyName(item.curNm))
                        .font(.headline)
                    Spacer()
                    Text("단위 : 1 \(item.curUnit)")
                    Text("송금 받을 때 : KRW \(item.ttb)원")
                    Text("송금 보낼 때 : KRW \(item.tts)원")
                }
                .padding(.vertical, 5)
            }
            .listStyle(PlainListStyle()) // 리스트 스타일 지정
        }
        .padding(.top)
        .onAppear {
            Task {
                do {
                    exchangeRates = try await getExchangeRates(date: "20240724")
                    dump(exchangeRates)
                } catch {
                    print("Failed to fetch data: \(error)")
                }
            }
        }

    }

    // 오늘 날짜 가져오기
    var todayDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: Date())
    }
    
    // ex ) "아랍에미리트 디르함" -> "아랍에미리트 (디르함)"으로 변환하는 함수
    func formatCurrencyName(_ curNm: String) -> String {
        // 공백을 기준으로 분할
        let parts = curNm.split(separator: " ")
        
        // 국가명과 통화명을 분리하고, 원하는 형식으로 반환
        if parts.count > 1 {
            let countryName = parts.dropLast().joined(separator: " ")
            let currencyName = parts.last ?? ""
            return "\(countryName) (\(currencyName))"
        } else {
            // 분할에 실패한 경우 원본 반환
            return curNm
        }
    }
}

struct ExchangeRate: Codable {
    let result: Int
    let curUnit, ttb, tts, dealBasR: String
    let bkpr, yyEfeeR, tenDDEfeeR, kftcBkpr: String
    let kftcDealBasR, curNm: String

    enum CodingKeys: String, CodingKey {
        case result
        case curUnit = "cur_unit"
        case ttb, tts
        case dealBasR = "deal_bas_r"
        case bkpr
        case yyEfeeR = "yy_efee_r"
        case tenDDEfeeR = "ten_dd_efee_r"
        case kftcBkpr = "kftc_bkpr"
        case kftcDealBasR = "kftc_deal_bas_r"
        case curNm = "cur_nm"
    }
}

func getExchangeRates(date: String) async throws -> [ExchangeRate] {
    // 도메인 넣어서 URL 컴포넌트 생성
    var components = URLComponents(string: "https://www.koreaexim.go.kr")
    // 도메인 뒤에 API 주소 삽입
    components?.path = "/site/program/financial/exchangeJSON"
    // 파라미터 추가할거 있으면 작성
    let parameters = [
        URLQueryItem(name: "authkey", value: "W9SdHOANcbqfmDDWCesypsUkrcpLhcXM"),
        URLQueryItem(name: "searchdate", value: date),
        URLQueryItem(name: "data", value: "AP01")
    ]
    
    components?.percentEncodedQueryItems = parameters
    // URL 생성
    guard let url = components?.url else {
        throw URLError(.badURL)
    }
  
    // 리퀘스트 생성
    var request = URLRequest(url: url)
    // 통신 방법 지정
    request.httpMethod = "GET"

    // 데이터와 응답을 비동기로 받음
    let (data, response) = try await URLSession.shared.data(for: request)

    // 응답 상태 코드 확인 (옵션)
    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
        throw URLError(.badServerResponse)
    }

    // JSON 디코딩
    let exchangeRates = try JSONDecoder().decode([ExchangeRate].self, from: data)

    return exchangeRates
}

#Preview {
    ExchageRateView(recordedItems: .constant([]))
}

