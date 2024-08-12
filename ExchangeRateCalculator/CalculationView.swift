//
//  CalculationView.swift
//  ExchangeRateCalculator
//
//  Created by 박상현 on 7/17/24.
//

import SwiftUI

enum ButtonType: String { // 버튼
    case first = "1", second = "2", third = "3", forth = "4", fifth = "5"
    case sixth = "6", seventh = "7", eighth = "8", nineth = "9", zero = "0"
    case dot = ".", equal = "=", plus = "+", minus = "-", multiple = "×", divide = "÷"
    case percent = "%", opposite = "+/-", clear = "C" //원시값이 없는 열거형
    
    var displayName: String { rawValue } //rowValue = 원시값
    
    var backgroundColor: Color { // 계산기 글자의 배경 색
        switch self {
        case .clear, .opposite, .percent:
            return Color.gray
        case .divide, .multiple, .minus, .plus, .equal:
            return Color.orange
        default:
            return Color(.darkGray)
        }
    } //switch self 는 열거형의 값에 대해 self 사용
    
    var foregroundColor: Color { //계산기 글자 색
        switch self {
        case .clear, .opposite, .percent:
            return Color.black
        default:
            return Color.white
        }
    }
}

enum Currency: String, CaseIterable { // CaseIterable은 .allCases를 사용해 자동 나열,반복 하기 위해 사용
    case 대한민국 = "KRW", 미국 = "USD", 중국 = "CNY", 일본 = "JPY", 유럽연합 = "EUR", 영국 = "GBP", 호주 = "AUD"
    
    var exchangeRate: Double { // 일단 환율에 대한 정보
        switch self {
        case .대한민국: return 1.0
        case .미국: return 0.00083
        case .중국: return 0.00147
        case .일본: return 0.00091
        case .유럽연합: return 0.00112
        case .영국: return 0.00128
        case .호주: return 0.00074
        }
    }
    
    var symbol: String { // 각 나라의 원화 단위
        switch self {
        case .대한민국: return "₩"
        case .미국: return "$"
        case .중국: return "CN¥"
        case .일본: return "¥"
        case .유럽연합: return "€"
        case .영국: return "£"
        case .호주: return "A$"
        }
    }
}

struct CalculationView: View {
    @State private var selectedCountry1 = Currency.대한민국 // 화면에 대한민국(krw)을 기본으로 나타냄
    @State private var selectedCountry2 = Currency.미국 // 화면에 미국(usd)을 기본으로 나타냄
    @State private var displayText = "0" // 나타내는 입력금액을 기본 0 으로 설정
    @State private var inputText = "" // 입력값
    @State private var convertedText = "0" // 출력값
    @State private var operatorType: ButtonType? = nil //?는 옵셔널타입, 값이 있을수도 없을수도 있다.
    @Binding var recordedItems: [String] //@state는 뷰 상태를 계속 보여주게 하고, @binding은 부모뷰의 데이터를 자식뷰가 사용

    private let buttonData: [[ButtonType]] = [
        [.clear, .opposite, .percent, .divide],
        [.seventh, .eighth, .nineth, .multiple],
        [.forth, .fifth, .sixth, .minus],
        [.first, .second, .third, .plus],
        [.zero, .dot, .equal]
    ] // 아마.. 사용을 위해 buttonData 라는 변수를 반들어 사용하려고 하는거 같은데..
    
    var body: some View {
        GeometryReader { geometry in // 부모뷰의 크기와 위치정보를 읽을 수 있게 해준다.
            VStack {
                countrySelectionView // 프로퍼티..? 나라 선택할 수 있도록 함/ 두개의 picker을 수평으로 배치
                
                Divider() // 선으로 분리
                
                HStack {
                    VStack(alignment: .leading) { // 정렬 이런걸로 알고있음
                        Text("입력 금액 (\(selectedCountry1.symbol))")
                        Text(displayText)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                    .padding()
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("변환 금액 (\(selectedCountry2.symbol))")
                        Text(convertedText)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }
                    .padding()
                }
                
                Divider()
                
                Spacer()
                
                // 버튼 모양들을 만들어냄
                VStack(spacing: 10) {
                    ForEach(buttonData, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row, id: \.self) { button in
                                Button(action: {
                                    handleButtonPress(button)
                                }) {
                                    Text(button.displayName)
                                        .font(.system(size: 33))
                                        .frame(width: self.buttonWidth(button), height: self.buttonHeight())
                                        .background(button.backgroundColor)
                                        .foregroundColor(button.foregroundColor)
                                        .cornerRadius(40)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom + 10) // ?
            }
            .edgesIgnoringSafeArea(.bottom) // ?
        }
    }
    //body는 실질적으로 화면에 나타낼 것들만 표현
    
    // 나라 선택을 할 수 있게함
    private var countrySelectionView: some View {
        HStack {
            Picker("기준 나라", selection: $selectedCountry1) {
                ForEach(Currency.allCases, id: \.self) { currency in
                    Text(currency.rawValue)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            Spacer()
            
            Picker("대상 나라", selection: $selectedCountry2) {
                ForEach(Currency.allCases, id: \.self) { currency in
                    Text(currency.rawValue)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
        }
    }
    
    // 버튼을 눌렀을 때
    private func handleButtonPress(_ button: ButtonType) { // 커스텀 타입의 사용
        switch button {
        case .clear:
            displayText = "0" // C를 눌렀을 때 0 으로 표시
            inputText = ""
            operatorType = nil
            convertedText = "0"
            
        case .opposite:
            if let value = Double(displayText) {
                displayText = String(value * -1)
            }

        case .divide, .multiple, .minus, .plus, .percent:
            operatorType = button
            inputText = displayText
            displayText = "0" // 입력값과 +,-,*,/ 연산된 값이 나오게.
            
        case .equal:
            if let value = performOperation() {
                displayText = String(value) // 결과를 업데이트
                let convertedValue = value * (selectedCountry2.exchangeRate / selectedCountry1.exchangeRate)
                convertedText = String(format: "%.2f", convertedValue)
                recordedItems.append("\(displayText) \(selectedCountry1.symbol) → \(convertedText) \(selectedCountry2.symbol)") // 계산 결과 기록
            }
        default:
            if displayText == "0" {
                displayText = button.displayName
            } else {
                displayText += button.displayName
            }
        }
    }
    
    
    // 실제 계산
    
    private func performOperation() -> Double? {
        guard let input = Double(inputText), let output = Double(displayText), let operation = operatorType else {
            return nil
        }
        
        switch operation {
        case .plus:
            return input + output
        case .minus:
            return input - output
        case .multiple:
            return input * output
        case .divide:
            return output != 0 ? input / output : nil
        case .percent:
            return input / 100
        default:
            return input
        }
    }
    
    // 기종에 따라 버튼 넓이
    private func buttonWidth(_ button: ButtonType) -> CGFloat {
        return button == .zero ? (UIScreen.main.bounds.width - 50) / 2 : (UIScreen.main.bounds.width - 60) / 4 // 버튼의 넓이
    }
    
    // 기종에 따라 버튼 높이
    private func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 60) / 4
    }
}

struct CalculationView_Previews: PreviewProvider {
    @State static var recordedItems: [String] = []
    
    static var previews: some View {
        CalculationView(recordedItems: $recordedItems)
    }
}


