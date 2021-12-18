//
//  ResultCard.swift
//  MobileNetV2
//
//  Created by Eli Hartnett on 12/17/21.
//

import SwiftUI

struct ResultCard: View {
    
    var identifier: String
    var confidence: Double
    var barColor: Color {
        if confidence < 0.3 {
            return .red
        }
        else if confidence >= 0.3 && confidence <= 0.7 {
            return .orange
        }
        else {
            return .green
        }
    }
    var geo: GeometryProxy
    
    var body: some View {
        HStack {
            Spacer()
            
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(identifier)
                            .bold()
                            .lineLimit(1)
                        HStack {
                            Text(String(format: "%.2f%%", confidence * 100))
                            Rectangle()
                                .fill(barColor)
                                .frame(width: (confidence/1) * geo.size.width/2, height: 10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .frame(width: (geo.size.width)-40, height: 75)
            
            Spacer()
        }
    }
}

struct ResultCard_Previews: PreviewProvider {
    
    static var previews: some View {
        GeometryReader { geo in
            ResultCard(identifier: "Dog", confidence: 1, geo: geo)
        }
    }
}
